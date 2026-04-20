//
//  ChildProfileViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation
import SwiftUI
import Combine


@MainActor
final class ChildProfileViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var month = ""
    @Published var day = ""
    @Published var year = ""
    @Published var gender: String = AppConstants.genderOptions.first ?? "Male"
    @Published var diet: String = AppConstants.defaultDiet
    
    @Published var imageUrl: String = ""
    @Published var selectedImage: UIImage?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var saveSucceeded: Bool = false
    
    let childId: String?
    let isFirstTimeUser: Bool
    
    private let dbService = FirebaseDBService()
    
    init(childId: String? = nil, isFirstTimeUser: Bool = false) {
        self.childId = childId
        self.isFirstTimeUser = isFirstTimeUser
    }
    
    var isEditMode: Bool {
        childId != nil
    }
    
    func loadInitialData() async {
        guard let childId else {
            diet = AppConstants.defaultDiet
            return
        }
        
        do {
            let child = try await dbService.fetchChild(childId: childId)
            firstName = child.firstName
            lastName = child.lastName
            birthDate = Self.dateFromString(child.birthDate) ?? Date()
            gender = child.gender.isEmpty ? AppConstants.genderOptions.first ?? "Male" : child.gender
            diet = child.diet.isEmpty ? AppConstants.defaultDiet : child.diet
            imageUrl = child.imageUrl
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func formatBirthDate(_ newValue: String) {
            let filtered = newValue.filter { "0123456789".contains($0) }
            
            var result = ""
            for (index, char) in filtered.enumerated() {
                if index == 2 || index == 4 {
                    result.append("/")
                }
                if index < 8 { // Max length MMDDYYYY
                    result.append(char)
                }
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            if let date = formatter.date(from: result) {
                self.birthDate = date
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
    
    func saveChild() {
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedFirst.isEmpty,
              !trimmedLast.isEmpty else {
            errorMessage = "Please fill in all required fields."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let formattedBirthDate = Self.stringFromDate(birthDate)
        
        Task {
            do {
                if let childId {
                    try await dbService.updateChild(
                        childId: childId,
                        firstName: trimmedFirst,
                        lastName: trimmedLast,
                        birthDate: formattedBirthDate,
                        gender: gender,
                        diet: diet,
                        imageUrl: imageUrl
                    )
                } else {
                    _ = try await dbService.addChild(
                        firstName: trimmedFirst,
                        lastName: trimmedLast,
                        birthDate: formattedBirthDate,
                        gender: gender,
                        diet: diet,
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
    
    static func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.string(from: date)
    }
    
    static func dateFromString(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.date(from: value)
    }
}
