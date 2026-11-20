//
//  AddAllergiesView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/26/26.
//


import SwiftUI

struct AddAllergiesView: View {

    @StateObject private var viewModel: AddAllergiesViewModel
    @Environment(\.dismiss) private var dismiss

    init(allergenId: String? = nil, isViewOnly: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: AddAllergiesViewModel(
                allergenId: allergenId,
                isViewOnly: isViewOnly
            )
        )
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

            // Header
            HStack {
                Text(viewModel.titleText)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 25)
            .frame(height: 67)
            .background(purple)

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    // Allergen Name
                    VStack(alignment: .leading, spacing: 6) {
                        fieldLabel("Allergen")

                        TextField(
                            "",
                            text: $viewModel.allergenName,
                            prompt: Text("Enter allergen name")
                                .foregroundColor(placeholderColor)
                        )
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .frame(height: 48)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                        .overlay {
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(purple, lineWidth: 1)
                        }
                        .disabled(viewModel.isViewOnly)
                    }

                    // IgE Allergen
                    Toggle(isOn: $viewModel.igE) {
                        fieldLabel("IgE Allergen")
                    }
                    .tint(purple)
                    .disabled(viewModel.isViewOnly)

                    // Date of Diagnosis
                    VStack(alignment: .leading, spacing: 6) {
                        fieldLabel("Date of diagnosis")

                        DatePicker(
                            "",
                            selection: $viewModel.diagnosisDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .tint(purple)
                        .padding(.horizontal, 12)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                        .overlay {
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(purple, lineWidth: 1)
                        }
                        .disabled(viewModel.isViewOnly)
                    }

                    // Severity
                    VStack(alignment: .leading, spacing: 6) {
                        fieldLabel("Severity")

                        Picker("Severity", selection: $viewModel.severity) {
                            ForEach(viewModel.severityOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(purple)
                        .padding(.horizontal, 12)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                        .overlay {
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(purple, lineWidth: 1)
                        }
                        .disabled(viewModel.isViewOnly)
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: 6) {
                        fieldLabel("Notes")

                        ZStack(alignment: .topLeading) {

                            if viewModel.notes.isEmpty {
                                Text("Enter additional notes")
                                    .font(.system(size: 14))
                                    .foregroundColor(placeholderColor)
                                    .padding(.horizontal, 9)
                                    .padding(.top, 8)
                            }

                            TextEditor(text: $viewModel.notes)
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 3)
                        }
                        .frame(height: 125)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(purple, lineWidth: 1)
                        }
                        .disabled(viewModel.isViewOnly)
                    }

                    // Allergen Cleared
                    Toggle(isOn: $viewModel.cleared) {
                        fieldLabel("Allergen Cleared")
                    }
                    .tint(purple)
                    .disabled(viewModel.isViewOnly)

                    // End Date
                    if viewModel.cleared {
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("End Date")

                            DatePicker(
                                "",
                                selection: $viewModel.clearedDate,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .tint(purple)
                            .padding(.horizontal, 12)
                            .frame(height: 48)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                            .overlay {
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(purple, lineWidth: 1)
                            }
                            .disabled(viewModel.isViewOnly)
                        }
                    }

                    // Error Message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 20)
            }

            // Save Button
            Button {
                if viewModel.isViewOnly && viewModel.allergenId == nil {
                    dismiss()
                } else {
                    viewModel.saveAllergen()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(coral)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                } else {
                    Text("Save allergen")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(coral)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .background(purple)
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .padding(.horizontal, 38)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .disabled(viewModel.isLoading)
        }
        .background(Color.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
        .task {
            await viewModel.loadAllergen()
        }
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                dismiss()
            }
        }
    }

    // MARK: - Field Label

    private func fieldLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(purple)
    }
}
