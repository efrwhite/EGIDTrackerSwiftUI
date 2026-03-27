//
//  AllergiesViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation
import Combine

@MainActor
final class AllergiesViewModel: ObservableObject {
    
    @Published var currentAllergies: [AllergenItem] = []
    @Published var pastAllergies: [AllergenItem] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let dbService = FirebaseDBService()
    
    func loadAllergies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let allergens = try await dbService.fetchAllergensForCurrentChild()
            
            let sorted = allergens.sorted {
                $0.allergenName.localizedCaseInsensitiveCompare($1.allergenName) == .orderedAscending
            }
            
            currentAllergies = sorted.filter { !$0.cleared }
            pastAllergies = sorted.filter { $0.cleared }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
