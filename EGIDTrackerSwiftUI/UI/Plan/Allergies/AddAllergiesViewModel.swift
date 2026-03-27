//
//  AddAllergiesViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/26/26.
//

import Foundation
import Combine

@MainActor
final class AddAllergiesViewModel: ObservableObject {
    
    @Published var allergenName: String = ""
    @Published var diagnosisDate: Date = Date()
    @Published var severity: String = "Select Severity"
    @Published var igE: Bool = false
    @Published var cleared: Bool = false
    @Published var clearedDate: Date = Date()
    @Published var notes: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var saveSucceeded: Bool = false
    
    let allergenId: String?
    let isViewOnly: Bool
    
    private let dbService = FirebaseDBService()
    
    let severityOptions = ["Select Severity", "Mild", "Moderate", "Severe"]
    
    init(allergenId: String? = nil, isViewOnly: Bool = false) {
        self.allergenId = allergenId
        self.isViewOnly = isViewOnly
    }
    
    var isEditMode: Bool {
        allergenId != nil
    }
    
    var titleText: String {
        if isViewOnly {
            return "View Cleared Allergen"
        } else if isEditMode {
            return "Edit Allergen"
        } else {
            return "Add Allergen"
        }
    }
    
    func loadAllergen() async {
        guard let allergenId else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let allergen = try await dbService.fetchAllergen(allergenId: allergenId)
            allergenName = allergen.allergenName
            diagnosisDate = Self.dateFromString(allergen.diagnosisDate) ?? Date()
            severity = allergen.severity
            igE = allergen.igE
            cleared = allergen.cleared
            clearedDate = Self.dateFromString(allergen.clearedDate) ?? Date()
            notes = allergen.notes
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func saveAllergen() {
        errorMessage = nil
        
        guard severity != "Select Severity" else {
            errorMessage = "Please select a severity."
            return
        }
        
        if cleared && falsePositiveClearedDate() {
            errorMessage = "Please enter a cleared date when clearing an allergen."
            return
        }
        
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child is currently selected."
            return
        }
        
        let allergen = AllergenItem(
            id: allergenId,
            allergenName: allergenName.trimmingCharacters(in: .whitespacesAndNewlines),
            diagnosisDate: Self.stringFromDate(diagnosisDate),
            severity: severity,
            igE: igE,
            cleared: cleared,
            clearedDate: cleared ? Self.stringFromDate(clearedDate) : "",
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            childId: childId
        )
        
        isLoading = true
        
        Task {
            do {
                if isViewOnly, let allergenId {
                    try await dbService.updateAllergenNotes(allergenId: allergenId, notes: allergen.notes)
                } else if isEditMode {
                    try await dbService.updateAllergen(allergen: allergen)
                } else {
                    try await dbService.addAllergen(allergen: allergen)
                }
                
                saveSucceeded = true
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    private func falsePositiveClearedDate() -> Bool {
        false
    }
    
    static func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
    
    static func dateFromString(_ value: String) -> Date? {
        guard !value.isEmpty else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.date(from: value)
    }
}
