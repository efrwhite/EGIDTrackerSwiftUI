//
//  PlanViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation
import Combine

@MainActor
final class PlanViewModel: ObservableObject {
    
    @Published var childName: String = "No Name"
    @Published var childDiet: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showDietError: Bool = false
    
    private let dbService = FirebaseDBService()
    
    func loadPlanData() async {
        isLoading = true
        errorMessage = nil
        showDietError = false
        
        do {
            guard let childId = dbService.getCurrentChildId() else {
                childName = "No Name"
                childDiet = ""
                isLoading = false
                return
            }
            
            let child = try await dbService.fetchChild(childId: childId)
            childName = child.firstName
            childDiet = child.diet.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func normalizedDietRoute() -> String? {
        let diet = childDiet.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch diet {
        case "diet 1":
            return "diet1"
        case "diet 2":
            return "diet2"
        case "diet 4":
            return "diet4"
        case "diet 6":
            return "diet6"
        case "no diet", "none", "":
            return "dietNone"
        default:
            return nil
        }
    }
}
