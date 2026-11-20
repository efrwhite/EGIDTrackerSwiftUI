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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let db = FirebaseDBService()

    func loadMedications() async {
        isLoading = true
        errorMessage = nil

        do {
            let meds = try await db.fetchMedications()

            activeMeds = meds.filter {
                !hasDiscontinuedDatePassed($0)
            }

            pastMeds = meds.filter {
                hasDiscontinuedDatePassed($0)
            }

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func parsedDate(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.date(from: value)
    }

    private func hasDiscontinuedDatePassed(
        _ med: MedicationItem
    ) -> Bool {

        guard med.discontinue, !med.endDate.isEmpty else {
            return false
        }

        guard let endDate = parsedDate(med.endDate) else {
            return false
        }

        return endDate < Calendar.current.startOfDay(for: Date())
    }
}
