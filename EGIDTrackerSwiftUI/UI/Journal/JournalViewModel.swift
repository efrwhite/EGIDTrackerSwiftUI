//
//  JournalViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import Foundation
import Combine

@MainActor
final class JournalViewModel: ObservableObject {
    
    @Published var selectedCategory: JournalCategory = .endoscopy
    @Published var entries: [JournalEntry] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let dbService = FirebaseDBService()
    
    func loadEntries() async {
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child selected."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            switch selectedCategory {
                
            case .endoscopy:
                let results = try await dbService.fetchEndoscopyResults(childId: childId)
                entries = results.map {
                    JournalEntry(
                        id: $0.id,
                        date: $0.date,
                        info: "Endoscopy",
                        category: .endoscopy
                    )
                }
                
            case .allergies:
                let allergies = try await dbService.fetchAllergensForCurrentChild()
                entries = allergies.map {
                    JournalEntry(
                        id: $0.id ?? UUID().uuidString,
                        date: parseDate($0.diagnosisDate),
                        info: $0.allergenName,
                        category: .allergies
                    )
                }
                
            case .medication:
                let medications = try await dbService.fetchMedications()
                entries = medications.map {
                    JournalEntry(
                        id: $0.id ?? UUID().uuidString,
                        date: parseDate($0.startDate),
                        info: $0.medName,
                        category: .medication
                    )
                }
                
            case .accidentalExposure:
                let exposures = try await dbService.fetchAccidentalExposureForCurrentChild()
                entries = exposures.map {
                    JournalEntry(
                        id: $0.id ?? UUID().uuidString,
                        date: parseDate($0.date),
                        info: $0.itemName,
                        category: .accidentalExposure
                    )
                }
                
            case .symptomScore:
                let results = try await dbService.fetchSymptomScoreRows(childId: childId)
                entries = results.map {
                    JournalEntry(
                        id: $0.id,
                        date: $0.date,
                        info: "Score: \($0.totalScore)",
                        category: .symptomScore
                    )
                }
                
            case .qualityOfLife:
                let results = try await dbService.fetchQoLScoreRows(childId: childId)
                entries = results.map {
                    JournalEntry(
                        id: $0.id,
                        date: $0.date,
                        info: "Score: \($0.totalScore)",
                        category: .qualityOfLife
                    )
                }
            }
            
            entries.sort { $0.date > $1.date }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func parseDate(_ value: String) -> Date {
        let formats = ["yyyy-MM-dd", "MM/dd/yyyy", "M/d/yyyy"]
        
        for format in formats {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            
            if let date = formatter.date(from: value) {
                return date
            }
        }
        
        return .distantPast
    }
}
