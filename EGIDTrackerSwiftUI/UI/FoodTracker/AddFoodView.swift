//
//  AddFoodView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import SwiftUI

struct AddFoodView: View {
    
    var existingEntry: FoodEntry?
    var selectedDate: String
    var onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var foodName = ""
    @State private var notes = ""
    @State private var date = Date()
    
    private let dbService = FirebaseDBService()
    
    var isEditing: Bool {
        existingEntry != nil
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(isEditing ? "Edit Food" : "Add Food")
                .font(.title2)
                .bold()
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
            
            TextField("Food Name", text: $foodName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Notes", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Button("Save") {
                Task { await save() }
            }
            .buttonStyle(.borderedProminent)
            
            if isEditing {
                Button("Delete") {
                    Task { await delete() }
                }
                .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            if let entry = existingEntry {
                foodName = entry.foodName
                notes = entry.notes
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                date = formatter.date(from: entry.date) ?? Date()
            }
        }
    }
    
    private func save() async {
        guard let childId = dbService.getCurrentChildId() else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let entry = FoodEntry(
            id: existingEntry?.id ?? UUID().uuidString,
            foodName: foodName,
            notes: notes,
            date: formatter.string(from: date)
        )
        
        do {
            if isEditing {
                try await dbService.updateFoodEntry(childId: childId, entry: entry)
            } else {
                try await dbService.addFoodEntry(childId: childId, entry: entry)
            }
            
            onSave()
            dismiss()
        } catch {
            print("Save failed:", error)
        }
    }
    
    private func delete() async {
        guard let childId = dbService.getCurrentChildId(),
              let id = existingEntry?.id else { return }
        
        do {
            try await dbService.deleteFoodEntry(childId: childId, entryId: id)
            onSave()
            dismiss()
        } catch {
            print("Delete failed:", error)
        }
    }
}
