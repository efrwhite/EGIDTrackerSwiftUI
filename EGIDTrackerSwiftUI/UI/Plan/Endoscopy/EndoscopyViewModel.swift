//
//  EndoscopyViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/30/26.
//

import Foundation
import Combine

@MainActor
final class EndoscopyViewModel: ObservableObject {
    
    @Published var date: Date = Date()
    @Published var notes: String = ""
    
    @Published var proximate: String = ""
    @Published var middle: String = ""
    @Published var lower: String = ""
    @Published var stomach: String = ""
    @Published var duodenum: String = ""
    @Published var rightColon: String = ""
    @Published var middleColon: String = ""
    @Published var leftColon: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var saveSucceeded = false
    
    let reportId: String?
    private let dbService = FirebaseDBService()
    
    init(reportId: String? = nil) {
        self.reportId = reportId
    }
    
    var isEditing: Bool {
        reportId != nil
    }
    
    func loadIfEditing() async {
        guard let reportId,
              let childId = dbService.getCurrentChildId() else { return }
        
        isLoading = true
        
        do {
            let result = try await dbService.fetchSingleEndoscopyResult(childId: childId, reportId: reportId)
            date = result.date
            notes = result.notes
            proximate = result.proximate.map(String.init) ?? ""
            middle = result.middle.map(String.init) ?? ""
            lower = result.lower.map(String.init) ?? ""
            stomach = result.stomach.map(String.init) ?? ""
            duodenum = result.duodenum.map(String.init) ?? ""
            rightColon = result.rightColon.map(String.init) ?? ""
            middleColon = result.middleColon.map(String.init) ?? ""
            leftColon = result.leftColon.map(String.init) ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func save() async {
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child selected."
            return
        }
        
        let result = EndoscopyResult(
            id: reportId ?? UUID().uuidString,
            totalScore: totalScore,
            proximate: Int(proximate),
            middle: Int(middle),
            lower: Int(lower),
            stomach: Int(stomach),
            duodenum: Int(duodenum),
            rightColon: Int(rightColon),
            middleColon: Int(middleColon),
            leftColon: Int(leftColon),
            date: date,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await dbService.saveEndoscopyResult(
                childId: childId,
                result: result,
                isEditing: isEditing
            )
            saveSucceeded = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    var totalScore: Int {
        [proximate, middle, lower, stomach, duodenum, rightColon, middleColon, leftColon]
            .compactMap { Int($0) }
            .reduce(0, +)
    }
}
