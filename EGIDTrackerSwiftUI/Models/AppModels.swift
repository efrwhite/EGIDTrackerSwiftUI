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
    let id: UUID
    let childId: String
    var displayName: String
    let storedFileName: String
    let originalExtension: String
    let type: String
    let size: Int64
    let date: Date
}

struct EndoscopyResult: Identifiable {
    var id: String
    var totalScore: Int
    var proximate: Int?
    var middle: Int?
    var lower: Int?
    var stomach: Int?
    var duodenum: Int?
    var rightColon: Int?
    var middleColon: Int?
    var leftColon: Int?
    var date: Date
    var notes: String
}

struct SymptomScoreResult: Identifiable {
    var id: String
    var totalScore: Int
    var responses: [String]
    var symptomDescriptions: [String]
    var date: Date
}

struct ScoreResultRow: Identifiable {
    var id: String
    var totalScore: Int
    var date: Date
}

struct QoLScoreResult: Identifiable {
    var id: String
    var totalScore: Int
    var responses: [Int]
    var date: Date
}

struct FoodEntry: Identifiable {
    var id: String
    var foodName: String
    var notes: String
    var date: String // yyyy-MM-dd
}

struct JournalEntry: Identifiable {
    var id: String
    var date: Date
    var info: String
    var category: JournalCategory
}

enum JournalCategory: String, CaseIterable, Identifiable {
    case endoscopy = "Endoscopy"
    case allergies = "Allergies"
    case medication = "Medication"
    case accidentalExposure = "Accidental Exposure"
    case symptomScore = "Symptom Score"
    case qualityOfLife = "Quality of Life"
    var id: String { rawValue }
}
