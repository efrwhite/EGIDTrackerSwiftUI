//
//  Untitled.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation
import Combine

@MainActor
final class ProfilesViewModel: ObservableObject {
    
    @Published var children: [ChildProfile] = []
    @Published var caregivers: [CaregiverProfile] = []
    @Published var activeChildName: String?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var didSelectChild: Bool = false
    
    private let dbService = FirebaseDBService()
    
    func loadProfiles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            children = try await dbService.fetchChildrenForCurrentUser()
            caregivers = try await dbService.fetchCaregiversForCurrentUser()
            activeChildName = dbService.getCurrentChildName()
            
            if let currentChildId = dbService.getCurrentChildId(),
               let matchingChild = children.first(where: { $0.id == currentChildId }) {
                dbService.saveCurrentChildName(matchingChild.firstName)
                activeChildName = matchingChild.firstName
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func selectChild(_ child: ChildProfile) {
        guard let childId = child.id else { return }
        
        let currentChildId = dbService.getCurrentChildId()
        if currentChildId == childId {
            errorMessage = "Currently selected."
            return
        }
        
        dbService.saveCurrentChildId(childId)
        dbService.saveCurrentChildName(child.firstName)
        activeChildName = child.firstName
        didSelectChild = true
    }
}
