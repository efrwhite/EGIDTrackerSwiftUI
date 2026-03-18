//
//  CaregiverProfileViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation
import PhotosUI
import SwiftUI
import Combine

@MainActor
final class CaregiverProfileViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    @Published var imageUrl: String = ""
    @Published var selectedImage: UIImage?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var saveSucceeded: Bool = false
    
    let isFirstTimeUser: Bool
    let caregiverId: String?
    
    private let dbService = FirebaseDBService()
    
    init(caregiverId: String? = nil, isFirstTimeUser: Bool = false) {
        self.caregiverId = caregiverId
        self.isFirstTimeUser = isFirstTimeUser
    }
    
    var isEditMode: Bool {
        caregiverId != nil
    }
    
    func loadInitialData() async {
        do {
            username = try await dbService.fetchUsernameForCurrentUser()
            
            if let caregiverId {
                let caregiver = try await dbService.fetchCaregiver(caregiverId: caregiverId)
                firstName = caregiver.firstName
                lastName = caregiver.lastName
                imageUrl = caregiver.imageUrl
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func setPickedImage(_ image: UIImage?, imagePath: String = "") {
        self.selectedImage = image
        self.imageUrl = imagePath
    }
    
    func deleteProfilePicture() {
        selectedImage = nil
        imageUrl = ""
    }
    
    func saveCaregiver() {
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedFirst.isEmpty, !trimmedLast.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                if let caregiverId {
                    try await dbService.updateCaregiver(
                        caregiverId: caregiverId,
                        firstName: trimmedFirst,
                        lastName: trimmedLast,
                        imageUrl: imageUrl
                    )
                } else {
                    _ = try await dbService.addCaregiver(
                        firstName: trimmedFirst,
                        lastName: trimmedLast,
                        imageUrl: imageUrl
                    )
                }
                
                saveSucceeded = true
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}
