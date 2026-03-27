//
//  AddMedicationViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/26/26.
//

import Foundation
import Combine

@MainActor
final class AddMedicationViewModel: ObservableObject {
    
    @Published var medName = ""
    @Published var dosage = ""
    @Published var startDate = Date()
    @Published var discontinuedDate = Date()
    @Published var frequency = ""
    @Published var notes = ""
    @Published var discontinue = false
    
    @Published var errorMessage: String?
    @Published var saveSucceeded = false
    @Published var isLoading = false
    
    let existingMedication: MedicationItem?
    let isViewOnly: Bool
    
    var canEditNotesOnly: Bool {
        isViewOnly
    }
    
    private let db = FirebaseDBService()
    
    init(medication: MedicationItem? = nil, isViewOnly: Bool = false) {
        self.existingMedication = medication
        self.isViewOnly = isViewOnly
        
        if let medication {
            self.medName = medication.medName
            self.dosage = medication.dosage
            self.startDate = Self.dateFromString(medication.startDate) ?? Date()
            self.frequency = medication.frequency
            self.notes = medication.notes
            self.discontinue = medication.discontinue
            
            if !medication.endDate.isEmpty {
                self.discontinuedDate = Self.dateFromString(medication.endDate) ?? Date()
            }
        }
    }
    
    var isEditMode: Bool {
        existingMedication != nil
    }
    
    var titleText: String {
        if isViewOnly {
            return "View Medication"
        } else if isEditMode {
            return "Edit Medication"
        } else {
            return "Add Medication"
        }
    }
    
    func save() async {
        let trimmedName = medName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDosage = dosage.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFrequency = frequency.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If this is view-only mode, only update notes
        if isViewOnly {
            guard let existingMedication else {
                errorMessage = "Medication not found."
                return
            }
            
            let updatedMed = MedicationItem(
                id: existingMedication.id,
                medName: existingMedication.medName,
                dosage: existingMedication.dosage,
                startDate: existingMedication.startDate,
                endDate: existingMedication.endDate,
                frequency: existingMedication.frequency,
                discontinue: existingMedication.discontinue,
                notes: trimmedNotes,
                childId: existingMedication.childId
            )
            
            isLoading = true
            errorMessage = nil
            
            do {
                try await db.updateMedication(updatedMed)
                saveSucceeded = true
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
            return
        }
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Medication name is required."
            return
        }
        
        guard !trimmedDosage.isEmpty else {
            errorMessage = "Dosage is required."
            return
        }
        
        guard !trimmedFrequency.isEmpty else {
            errorMessage = "Frequency is required."
            return
        }
        
        if discontinue && discontinuedDate <= startDate {
            errorMessage = "Discontinued date must be after the start date."
            return
        }
        
        guard let childId = db.getCurrentChildId() else {
            errorMessage = "No child is currently selected."
            return
        }
        
        let med = MedicationItem(
            id: existingMedication?.id,
            medName: trimmedName,
            dosage: trimmedDosage,
            startDate: Self.formatDate(startDate),
            endDate: discontinue ? Self.formatDate(discontinuedDate) : "",
            frequency: trimmedFrequency,
            discontinue: discontinue,
            notes: trimmedNotes,
            childId: childId
        )
        
        isLoading = true
        errorMessage = nil
        
        do {
            if isEditMode {
                try await db.updateMedication(med)
            } else {
                try await db.addMedication(med)
            }
            saveSucceeded = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
    
    static func dateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.date(from: string)
    }
}
