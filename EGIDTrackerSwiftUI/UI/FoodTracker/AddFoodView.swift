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

    private var isEditing: Bool {
        existingEntry != nil
    }

    // MARK: - Colors

    private let purple = Color(
        red: 91 / 255.0,
        green: 58 / 255.0,
        blue: 130 / 255.0
    )

    private let coral = Color(
        red: 255 / 255.0,
        green: 143 / 255.0,
        blue: 112 / 255.0
    )

    private let placeholderColor = Color(
        red: 145 / 255.0,
        green: 133 / 255.0,
        blue: 166 / 255.0
    )

    // MARK: - Main View

    var body: some View {
        VStack(spacing: 0) {

            // Purple Header
            HStack {
                Text("Food Tracker")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 25)
            .frame(height: 67)
            .background(purple)

            // Form Content
            VStack(alignment: .leading, spacing: 14) {

                // Date
                VStack(alignment: .leading, spacing: 5) {
                    fieldLabel("Date")

                    DatePicker(
                        "",
                        selection: $date,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(purple)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 43)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .overlay {
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(purple, lineWidth: 1)
                    }
                }

                // Food Name
                VStack(alignment: .leading, spacing: 5) {
                    fieldLabel("Food Name")

                    TextField(
                        "",
                        text: $foodName,
                        prompt: Text("e.g. Eggs, fried rice")
                            .foregroundColor(placeholderColor)
                    )
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .frame(height: 43)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .overlay {
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(purple, lineWidth: 1)
                    }
                }

                // Notes
                VStack(alignment: .leading, spacing: 5) {
                    fieldLabel("Notes")

                    ZStack(alignment: .topLeading) {

                        if notes.isEmpty {
                            Text("Brand, portion, how you felt after")
                                .font(.system(size: 14))
                                .foregroundColor(placeholderColor)
                                .padding(.horizontal, 9)
                                .padding(.top, 8)
                        }

                        TextEditor(text: $notes)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                    }
                    .frame(height: 107)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(purple, lineWidth: 1)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)

            Spacer(minLength: 0)

            // Bottom Buttons
            VStack(spacing: 9) {

                // Save Food
                Button {
                    Task {
                        await save()
                    }
                } label: {
                    Text("Save food")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(purple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(coral)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                }

                // Delete Entry
                if isEditing {
                    Button {
                        Task {
                            await delete()
                        }
                    } label: {
                        Text("Delete entry")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(coral)
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(purple)
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                    }
                }
            }
            .padding(.horizontal, 38)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
        .onAppear {
            loadEntry()
        }
    }

    // MARK: - Field Label

    private func fieldLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(purple)
    }

    // MARK: - Load Existing Entry

    private func loadEntry() {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let entry = existingEntry {

            foodName = entry.foodName
            notes = entry.notes
            date = formatter.date(from: entry.date) ?? Date()

        } else {

            date = formatter.date(from: selectedDate) ?? Date()
        }
    }

    // MARK: - Save Food

    private func save() async {

        guard let childId = dbService.getCurrentChildId() else {
            return
        }

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
                try await dbService.updateFoodEntry(
                    childId: childId,
                    entry: entry
                )
            } else {
                try await dbService.addFoodEntry(
                    childId: childId,
                    entry: entry
                )
            }

            onSave()
            dismiss()

        } catch {
            print("Save failed:", error)
        }
    }

    // MARK: - Delete Food

    private func delete() async {

        guard
            let childId = dbService.getCurrentChildId(),
            let id = existingEntry?.id
        else {
            return
        }

        do {

            try await dbService.deleteFoodEntry(
                childId: childId,
                entryId: id
            )

            onSave()
            dismiss()

        } catch {
            print("Delete failed:", error)
        }
    }
}
