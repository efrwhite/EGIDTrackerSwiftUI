//
//  Firebase.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/4/26.
//
//  Use this service to read/write to Firebase

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class FirebaseDBService {
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    private func currentUID() throws -> String {
        guard let uid = auth.currentUser?.uid else {
            throw DBServiceError.noAuthenticatedUser
        }
        return uid
    }
    
    // MARK: - Users
    
    func fetchUsernameForCurrentUser() async throws -> String {
        let uid = try currentUID()
        let doc = try await db.collection("Users").document(uid).getDocument()
        
        guard doc.exists else {
            throw DBServiceError.userDocumentNotFound
        }
        
        let username = doc.get("username") as? String ?? ""
        return username
    }
    
    // MARK: - Caregivers
    
    func addCaregiver(firstName: String, lastName: String, imageUrl: String) async throws -> String {
        let uid = try currentUID()
        
        let caregiverData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "parentUserId": uid,
            "imageUrl": imageUrl
        ]
        
        let ref = try await db.collection("Caregivers").addDocument(data: caregiverData)
        return ref.documentID
    }
    
    func updateCaregiver(caregiverId: String, firstName: String, lastName: String, imageUrl: String) async throws {
        let uid = try currentUID()
        
        let caregiverData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "parentUserId": uid,
            "imageUrl": imageUrl
        ]
        
        try await db.collection("Caregivers").document(caregiverId).setData(caregiverData)
    }
    
    func fetchCaregiver(caregiverId: String) async throws -> CaregiverProfile {
        let doc = try await db.collection("Caregivers").document(caregiverId).getDocument()
        
        guard doc.exists else {
            throw DBServiceError.caregiverNotFound
        }
        
        return CaregiverProfile(
            id: doc.documentID,
            username: "",
            firstName: doc.get("firstName") as? String ?? "",
            lastName: doc.get("lastName") as? String ?? "",
            imageUrl: doc.get("imageUrl") as? String ?? ""
        )
    }
    
    // MARK: - Children
    
    func addChild(firstName: String,
                  lastName: String,
                  birthDate: String,
                  gender: String,
                  diet: String,
                  imageUrl: String) async throws -> String {
        
        let uid = try currentUID()
        
        let childData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "birthDate": birthDate,
            "gender": gender,
            "diet": diet,
            "parentUserId": uid,
            "imageUrl": imageUrl
        ]
        
        let ref = try await db.collection("Children").addDocument(data: childData)
        saveCurrentChildId(ref.documentID)
        return ref.documentID
    }
    
    func updateChild(childId: String,
                     firstName: String,
                     lastName: String,
                     birthDate: String,
                     gender: String,
                     diet: String,
                     imageUrl: String?) async throws {
        
        let uid = try currentUID()
        
        var childData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "birthDate": birthDate,
            "gender": gender,
            "diet": diet,
            "parentUserId": uid
        ]
        
        if let imageUrl {
            childData["imageUrl"] = imageUrl
        }
        
        try await db.collection("Children").document(childId).setData(childData)
    }
    
    func fetchChild(childId: String) async throws -> ChildProfile {
        let doc = try await db.collection("Children").document(childId).getDocument()
        
        guard doc.exists else {
            throw DBServiceError.childNotFound
        }
        
        return ChildProfile(
            id: doc.documentID,
            firstName: doc.get("firstName") as? String ?? "",
            lastName: doc.get("lastName") as? String ?? "",
            birthDate: doc.get("birthDate") as? String ?? "",
            gender: doc.get("gender") as? String ?? "",
            diet: doc.get("diet") as? String ?? AppConstants.defaultDiet,
            imageUrl: doc.get("imageUrl") as? String ?? ""
        )
    }
    
    // MARK: - Local current child
    
    func getCurrentChildId() -> String? {
            guard let uid = auth.currentUser?.uid else { return nil }
            return UserDefaults.standard.string(forKey: "CurrentChildId_\(uid)")
        }
        
    func saveCurrentChildId(_ childId: String) {
        guard let uid = auth.currentUser?.uid else { return }
        UserDefaults.standard.set(childId, forKey: "CurrentChildId_\(uid)")
    }
    
    func removeCurrentChildId() {
        guard let uid = auth.currentUser?.uid else { return }
        UserDefaults.standard.removeObject(forKey: "CurrentChildId_\(uid)")
    }
    
    func fetchSelectedOrDefaultChild() async throws -> ChildProfile? {
        let uid = try currentUID()
        
        if let savedChildId = getCurrentChildId() {
            let doc = try await db.collection("Children").document(savedChildId).getDocument()
            
            if doc.exists {
                let parentUserId = doc.get("parentUserId") as? String ?? ""
                if parentUserId == uid {
                    let child = ChildProfile(
                        id: doc.documentID,
                        firstName: doc.get("firstName") as? String ?? "No Name",
                        lastName: doc.get("lastName") as? String ?? "",
                        birthDate: doc.get("birthDate") as? String ?? "",
                        gender: doc.get("gender") as? String ?? "",
                        diet: doc.get("diet") as? String ?? "No Diet Specified",
                        imageUrl: doc.get("imageUrl") as? String ?? ""
                    )
                    
                    saveCurrentChildName(child.firstName)
                    return child
                }
            }
            
            removeCurrentChildId()
        }
        
        let snapshot = try await db.collection("Children")
            .whereField("parentUserId", isEqualTo: uid)
            .limit(to: 1)
            .getDocuments()
        
        guard let childDoc = snapshot.documents.first else {
            return nil
        }
        
        saveCurrentChildId(childDoc.documentID)
        
        let child = ChildProfile(
            id: childDoc.documentID,
            firstName: childDoc.get("firstName") as? String ?? "No Name",
            lastName: childDoc.get("lastName") as? String ?? "",
            birthDate: childDoc.get("birthDate") as? String ?? "",
            gender: childDoc.get("gender") as? String ?? "",
            diet: childDoc.get("diet") as? String ?? "No Diet Specified",
            imageUrl: childDoc.get("imageUrl") as? String ?? ""
        )
        
        saveCurrentChildName(child.firstName)
        return child
    }
    
    func getCurrentChildName() -> String? {
        guard let uid = auth.currentUser?.uid else { return nil }
        return UserDefaults.standard.string(forKey: "CurrentChildName_\(uid)")
    }
    
    func saveCurrentChildName(_ childName: String) {
        guard let uid = auth.currentUser?.uid else { return }
        UserDefaults.standard.set(childName, forKey: "CurrentChildName_\(uid)")
    }
    
    func removeCurrentChildName() {
        guard let uid = auth.currentUser?.uid else { return }
        UserDefaults.standard.removeObject(forKey: "CurrentChildName_\(uid)")
    }
    
    // MARK: - Profile lists
    
    func fetchChildrenForCurrentUser() async throws -> [ChildProfile] {
        let uid = try currentUID()
        
        let snapshot = try await db.collection("Children")
            .whereField("parentUserId", isEqualTo: uid)
            .getDocuments()
        
        return snapshot.documents.map { doc in
            ChildProfile(
                id: doc.documentID,
                firstName: doc.get("firstName") as? String ?? "No Name",
                lastName: doc.get("lastName") as? String ?? "",
                birthDate: doc.get("birthDate") as? String ?? "",
                gender: doc.get("gender") as? String ?? "",
                diet: doc.get("diet") as? String ?? AppConstants.defaultDiet,
                imageUrl: doc.get("imageUrl") as? String ?? ""
            )
        }
    }
    
    func fetchCaregiversForCurrentUser() async throws -> [CaregiverProfile] {
        let uid = try currentUID()
        
        let snapshot = try await db.collection("Caregivers")
            .whereField("parentUserId", isEqualTo: uid)
            .getDocuments()
        
        return snapshot.documents.map { doc in
            CaregiverProfile(
                id: doc.documentID,
                username: "",
                firstName: doc.get("firstName") as? String ?? "No Name",
                lastName: doc.get("lastName") as? String ?? "",
                imageUrl: doc.get("imageUrl") as? String ?? ""
            )
        }
    }
    
    // MARK: - Allergens
    
    func fetchAllergensForCurrentChild() async throws -> [AllergenItem] {
        guard let childId = getCurrentChildId() else {
            return []
        }
        
        let snapshot = try await db.collection("Allergens")
            .whereField("childId", isEqualTo: childId)
            .getDocuments()
        
        return snapshot.documents.map { doc in
            AllergenItem(
                id: doc.documentID,
                allergenName: doc.get("allergenName") as? String ?? "",
                diagnosisDate: doc.get("diagnosisDate") as? String ?? "",
                severity: doc.get("severity") as? String ?? "Select Severity",
                igE: doc.get("igE") as? Bool ?? false,
                cleared: doc.get("cleared") as? Bool ?? false,
                clearedDate: doc.get("clearedDate") as? String ?? "",
                notes: doc.get("notes") as? String ?? "",
                childId: doc.get("childId") as? String ?? ""
            )
        }
    }
    
    func addAllergen(allergen: AllergenItem) async throws {
        let allergenMap: [String: Any] = [
            "allergenName": allergen.allergenName,
            "diagnosisDate": allergen.diagnosisDate,
            "severity": allergen.severity,
            "igE": allergen.igE,
            "cleared": allergen.cleared,
            "clearedDate": allergen.clearedDate,
            "notes": allergen.notes,
            "childId": allergen.childId
        ]
        
        _ = try await db.collection("Allergens").addDocument(data: allergenMap)
    }
    
    func updateAllergen(allergen: AllergenItem) async throws {
        guard let allergenId = allergen.id else {
            throw DBServiceError.allergenNotFound
        }
        
        let allergenMap: [String: Any] = [
            "allergenName": allergen.allergenName,
            "diagnosisDate": allergen.diagnosisDate,
            "severity": allergen.severity,
            "igE": allergen.igE,
            "cleared": allergen.cleared,
            "clearedDate": allergen.clearedDate,
            "notes": allergen.notes,
            "childId": allergen.childId
        ]
        
        try await db.collection("Allergens").document(allergenId).setData(allergenMap)
    }
    
    func updateAllergenNotes(allergenId: String, notes: String) async throws {
        try await db.collection("Allergens").document(allergenId).updateData([
            "notes": notes
        ])
    }
    
    func fetchAllergen(allergenId: String) async throws -> AllergenItem {
        let doc = try await db.collection("Allergens").document(allergenId).getDocument()
        
        guard doc.exists else {
            throw DBServiceError.allergenNotFound
        }
        
        return AllergenItem(
            id: doc.documentID,
            allergenName: doc.get("allergenName") as? String ?? "",
            diagnosisDate: doc.get("diagnosisDate") as? String ?? "",
            severity: doc.get("severity") as? String ?? "Select Severity",
            igE: doc.get("igE") as? Bool ?? false,
            cleared: doc.get("cleared") as? Bool ?? false,
            clearedDate: doc.get("clearedDate") as? String ?? "",
            notes: doc.get("notes") as? String ?? "",
            childId: doc.get("childId") as? String ?? ""
        )
    }
    
    // MARK: - Accidental Exposure
    
    func addAccidentalExposure(item: AccidentalExposureItem) async throws {
        let itemMap: [String: Any] = [
            "itemName": item.itemName,
            "description": item.description,
            "date": item.date,
            "childId": item.childId
        ]
        
        _ = try await db.collection("AccidentalExposure").addDocument(data: itemMap)
    }
    
    func fetchAccidentalExposureForCurrentChild() async throws -> [AccidentalExposureItem] {
        guard let childId = getCurrentChildId() else {
            return []
        }
        
        let snapshot = try await db.collection("AccidentalExposure")
            .whereField("childId", isEqualTo: childId)
            .getDocuments()
        
        return snapshot.documents.map { doc in
            AccidentalExposureItem(
                id: doc.documentID,
                itemName: doc.get("itemName") as? String ?? "No Name",
                description: doc.get("description") as? String ?? "",
                date: doc.get("date") as? String ?? "",
                childId: doc.get("childId") as? String ?? ""
            )
        }
    }
    
    // MARK: - Medications

    func fetchMedications() async throws -> [MedicationItem] {
        let childId = getCurrentChildId()
        
        let snapshot = try await db.collection("Medications")
            .whereField("childId", isEqualTo: childId ?? "")
            .getDocuments()
        
        return snapshot.documents.map { doc in
            MedicationItem(
                id: doc.documentID,
                medName: doc.get("medName") as? String ?? "",
                dosage: doc.get("dosage") as? String ?? "",
                startDate: doc.get("startDate") as? String ?? "",
                endDate: doc.get("endDate") as? String ?? "",
                frequency: doc.get("frequency") as? String ?? "",
                discontinue: doc.get("discontinue") as? Bool ?? false,
                notes: doc.get("notes") as? String ?? "",
                childId: doc.get("childId") as? String ?? ""
            )
        }
    }

    func addMedication(_ med: MedicationItem) async throws {
        var data: [String: Any] = [
            "medName": med.medName,
            "dosage": med.dosage,
            "startDate": med.startDate,
            "endDate": med.endDate,
            "frequency": med.frequency,
            "discontinue": med.discontinue,
            "notes": med.notes,
            "childId": med.childId
        ]
        
        try await db.collection("Medications").addDocument(data: data)
    }

    func updateMedication(_ med: MedicationItem) async throws {
        guard let id = med.id else { return }
        
        let data: [String: Any] = [
            "medName": med.medName,
            "dosage": med.dosage,
            "startDate": med.startDate,
            "endDate": med.endDate,
            "frequency": med.frequency,
            "discontinue": med.discontinue,
            "notes": med.notes,
            "childId": med.childId
        ]
        
        try await db.collection("Medications").document(id).setData(data)
    }
}

enum DBServiceError: LocalizedError {
    case noAuthenticatedUser
    case userDocumentNotFound
    case caregiverNotFound
    case childNotFound
    case allergenNotFound
    
    var errorDescription: String? {
        switch self {
        case .noAuthenticatedUser:
            return "No authenticated user was found."
        case .userDocumentNotFound:
            return "User profile was not found."
        case .caregiverNotFound:
            return "Caregiver not found."
        case .childNotFound:
            return "Child not found."
        case .allergenNotFound:
            return "Allergen not found."
        }
    }
}
