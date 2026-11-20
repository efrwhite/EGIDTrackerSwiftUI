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

    init(
        medication: MedicationItem? = nil,
        isViewOnly: Bool = false
    ) {
        _viewModel = StateObject(
            wrappedValue: AddMedicationViewModel(
                medication: medication,
                isViewOnly: isViewOnly
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text(viewModel.titleText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(MedicationTheme.purple)
                    .frame(maxWidth: .infinity, alignment: .center)

                Group {
                    medicationField(
                        title: "Medication Name",
                        placeholder: "Enter medication name",
                        text: $viewModel.medName
                    )

                    medicationField(
                        title: "Dosage",
                        placeholder: "Enter dosage",
                        text: $viewModel.dosage
                    )

                    medicationField(
                        title: "Frequency",
                        placeholder: "Enter frequency",
                        text: $viewModel.frequency
                    )
                }
                .disabled(viewModel.isViewOnly)

                dateSection(
                    title: "Start Date",
                    date: $viewModel.startDate
                )
                .disabled(viewModel.isViewOnly)

                Toggle("Discontinued", isOn: $viewModel.discontinue)
                    .tint(MedicationTheme.purple)
                    .padding()
                    .background(MedicationTheme.lightLavender)
                    .cornerRadius(12)
                    .disabled(viewModel.isViewOnly)

                if viewModel.discontinue {
                    dateSection(
                        title: "Discontinued Date",
                        date: $viewModel.discontinuedDate
                    )
                    .disabled(viewModel.isViewOnly)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                        .foregroundColor(MedicationTheme.purple)

                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 130)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.gray.opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                }

                Button {
                    Task {
                        await viewModel.save()
                    }
                } label: {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(
                                viewModel.isViewOnly
                                ? "Save Notes"
                                : "Save Medication"
                            )
                            .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(MedicationTheme.coral)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("Medication")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                dismiss()
            }
        }
        .preferredColorScheme(.light)
    }

    private func medicationField(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(MedicationTheme.purple)

            TextField(placeholder, text: text)
                .padding()
                .background(MedicationTheme.lightLavender)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color.gray.opacity(0.2),
                            lineWidth: 1
                        )
                )
        }
    }

    private func dateSection(
        title: String,
        date: Binding<Date>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(MedicationTheme.purple)

            DatePicker(
                "",
                selection: date,
                displayedComponents: .date
            )
            .labelsHidden()
            .tint(MedicationTheme.purple)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(MedicationTheme.lightLavender)
        .cornerRadius(12)
    }
}
