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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                Text(viewModel.titleText)
                    .font(.title2)
                    .bold()
                
                TextField("Allergen", text: $viewModel.allergenName)
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.isViewOnly)
                
                DatePicker(
                    "Date of Diagnosis",
                    selection: $viewModel.diagnosisDate,
                    displayedComponents: .date
                )
                .disabled(viewModel.isViewOnly)
                
                Picker("Severity", selection: $viewModel.severity) {
                    ForEach(viewModel.severityOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .disabled(viewModel.isViewOnly)
                
                Toggle("IgE Allergen", isOn: $viewModel.igE)
                    .disabled(viewModel.isViewOnly)
                
                Toggle("Cleared Allergen", isOn: $viewModel.cleared)
                    .disabled(viewModel.isViewOnly)
                
                if viewModel.cleared {
                    DatePicker(
                        "Allergen Cleared",
                        selection: $viewModel.clearedDate,
                        displayedComponents: .date
                    )
                    .disabled(viewModel.isViewOnly)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 140)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                        )
                }
                
                Button {
                    if viewModel.isViewOnly && viewModel.allergenId == nil {
                        dismiss()
                    } else {
                        viewModel.saveAllergen()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text(buttonTitle)
                            .bold()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .navigationTitle("Allergies")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadAllergen()
        }
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                dismiss()
            }
        }
    }
    
    private var buttonTitle: String {
        if viewModel.isViewOnly {
            return "Save"
        } else if viewModel.isEditMode {
            return "Save"
        } else {
            return "Save"
        }
    }
}
