//
//  HomeViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/4/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var childName: String = "No Child"
    @Published var childDiet: String = "No Diet Specified"
    @Published var childImageUrl: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var didLogOut: Bool = false
    
    private let dbService = FirebaseDBService()
    private let authService = FirebaseAuthService()
    
    struct ChildProfile {
        let id: String?
        var firstName: String
        var lastName: String
        var birthDate: String
        var gender: String
        var diet: String
        var imageUrl: String
    }
    
    func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            if let child = try await dbService.fetchSelectedOrDefaultChild() {
                childName = child.firstName
                childDiet = child.diet
                childImageUrl = child.imageUrl
            } else {
                childName = "No Child"
                childDiet = "No Diet Specified"
                childImageUrl = ""
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logOut() {
        do {
            dbService.removeCurrentChildId()
            dbService.removeCurrentChildName()
            try authService.signOut()
            didLogOut = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
