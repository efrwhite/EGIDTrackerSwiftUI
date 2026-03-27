//
//  MedicationsViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/26/26.
//

import Foundation
import Combine

@MainActor
final class MedicationsViewModel: ObservableObject {
    
    @Published var activeMeds: [MedicationItem] = []
    @Published var pastMeds: [MedicationItem] = []
    
    private let db = FirebaseDBService()
    
    func loadMedications() async {
        do {
            let meds = try await db.fetchMedications()
            
            activeMeds = meds.filter { !hasDiscontinuedDatePassed($0) }
            pastMeds = meds.filter { hasDiscontinuedDatePassed($0) }
            
        } catch {
            print("Error loading meds:", error)
        }
    }
    
    private func parsedDate(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.date(from: value)
    }

    private func hasDiscontinuedDatePassed(_ med: MedicationItem) -> Bool {
        guard med.discontinue, !med.endDate.isEmpty else { return false }
        guard let endDate = parsedDate(med.endDate) else { return false }
        return endDate < Calendar.current.startOfDay(for: Date())
    }
}
