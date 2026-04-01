//
//  ResultsViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/30/26.
//

import Foundation
import Combine

enum ResultsSource {
    case endoscopy
    case symptomChecker
    case qol
}

@MainActor
final class ResultsViewModel: ObservableObject {
    
    @Published var endoscopyResults: [EndoscopyResult] = []
    @Published var scoreResults: [ScoreResultRow] = []
    
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    let source: ResultsSource
    private let dbService = FirebaseDBService()
    
    init(source: ResultsSource) {
        self.source = source
    }
    
    func loadResults() async {
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child selected."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let endInclusive = endDate.map { date in
                Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? date
            }
            
            switch source {
            case .endoscopy:
                endoscopyResults = try await dbService.fetchEndoscopyResults(
                    childId: childId,
                    startDate: startDate,
                    endDate: endInclusive
                )
                scoreResults = []
                
            case .symptomChecker:
                scoreResults = try await dbService.fetchSymptomScoreRows(
                    childId: childId,
                    startDate: startDate,
                    endDate: endInclusive
                )
                endoscopyResults = []
                
            case .qol:
                scoreResults = try await dbService.fetchQoLScoreRows(
                    childId: childId,
                    startDate: startDate,
                    endDate: endInclusive
                )
                endoscopyResults = []
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
