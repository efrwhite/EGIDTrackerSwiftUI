//
//  ProfileModels.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation

struct CaregiverProfile {
    let id: String?
    var username: String
    var firstName: String
    var lastName: String
    var imageUrl: String
}

struct ChildProfile {
    let id: String?
    var firstName: String
    var lastName: String
    var birthDate: String
    var gender: String
    var diet: String
    var imageUrl: String
}

struct AllergenItem {
    let id: String?
    var allergenName: String
    var diagnosisDate: String
    var severity: String
    var igE: Bool
    var cleared: Bool
    var clearedDate: String
    var notes: String
    var childId: String
}

struct AccidentalExposureItem {
    let id: String?
    var itemName: String
    var description: String
    var date: String
    var childId: String
}

struct MedicationItem {
    let id: String?
    var medName: String
    var dosage: String
    var startDate: String
    var endDate: String
    var frequency: String
    var discontinue: Bool
    var notes: String
    var childId: String
}

struct StoredDocument: Identifiable, Codable {
    var id: UUID
    var childId: String
    var name: String
    var filePath: String
    var type: String
    var size: Int64
    var date: Date
}
