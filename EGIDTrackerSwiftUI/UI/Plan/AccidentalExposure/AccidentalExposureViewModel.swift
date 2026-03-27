//
//  AccidentalExposureViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/26/26.
//

import Foundation
import Combine

@MainActor
final class AccidentalExposureViewModel: ObservableObject {
    
    @Published var itemName: String = ""
    @Published var description: String = ""
    @Published var selectedDate: Date = Date()
    
    @Published var history: [AccidentalExposureItem] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var saveSucceeded: Bool = false
    
    private let dbService = FirebaseDBService()
    
    func loadHistory() async {
        isLoading = true
        errorMessage = nil
        
        do {
            history = try await dbService.fetchAccidentalExposureForCurrentChild()
                .sorted {
                    $0.date > $1.date
                }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func saveItem() {
        let trimmedItemName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedItemName.isEmpty else {
            errorMessage = "Please fill out both the date and item name."
            return
        }
        
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child is currently selected."
            return
        }
        
        let newItem = AccidentalExposureItem(
            id: nil,
            itemName: trimmedItemName,
            description: trimmedDescription,
            date: Self.stringFromDate(selectedDate),
            childId: childId
        )
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await dbService.addAccidentalExposure(item: newItem)
                
                itemName = ""
                description = ""
                selectedDate = Date()
                saveSucceeded = true
                
                await loadHistory()
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    static func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
}
