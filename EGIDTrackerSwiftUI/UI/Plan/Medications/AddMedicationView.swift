//
//  AddMedicationView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/26/26.
//

import SwiftUI

struct AddMedicationView: View {
    
    @StateObject private var viewModel: AddMedicationViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(medication: MedicationItem? = nil, isViewOnly: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: AddMedicationViewModel(
                medication: medication,
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
                
                Group {
                    TextField("Medication Name", text: $viewModel.medName)
                    TextField("Dosage", text: $viewModel.dosage)
                    TextField("Frequency", text: $viewModel.frequency)
                }
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.isViewOnly)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Start Date")
                        .font(.headline)
                    DatePicker(
                        "",
                        selection: $viewModel.startDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .disabled(viewModel.isViewOnly)
                
                Toggle("Discontinued", isOn: $viewModel.discontinue)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .disabled(viewModel.isViewOnly)
                
                if viewModel.discontinue {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Discontinued Date")
                            .font(.headline)
                        DatePicker(
                            "",
                            selection: $viewModel.discontinuedDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
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
                    Task {
                        await viewModel.save()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text(viewModel.isViewOnly ? "Save Notes" : "Save")
                            .bold()
                            .frame(maxWidth: .infinity)
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
        .navigationTitle("Medication")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                dismiss()
            }
        }
    }
}
