//
//  FoodTrackerViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import Foundation
import Combine

@MainActor
final class FoodTrackerViewModel: ObservableObject {
    
    @Published var selectedDate: String = ""
    @Published var entries: [FoodEntry] = []
    
    private let dbService = FirebaseDBService()
    
    init() {
        selectedDate = Self.currentDateString()
    }
    
    func loadEntries() async {
        guard let childId = dbService.getCurrentChildId() else { return }
        
        do {
            let allEntries = try await dbService.fetchFoodEntries(childId: childId)
            
            entries = allEntries.filter { $0.date == selectedDate }
        } catch {
            print("Failed to load food entries:", error)
        }
    }
    
    static func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func updateDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(from: date)
    }
}
