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
}

enum DBServiceError: LocalizedError {
    case noAuthenticatedUser
    case userDocumentNotFound
    case caregiverNotFound
    case childNotFound
    
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
        }
    }
}
