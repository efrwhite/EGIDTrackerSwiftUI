//
//  Medications.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//


import SwiftUI

struct MedicationsView: View {
    @StateObject private var viewModel = MedicationsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                HStack {
                    Text("Current Medications")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(MedicationTheme.purple)

                    Spacer()

                    NavigationLink {
                        AddMedicationView()
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(MedicationTheme.purple)
                        .cornerRadius(10)
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .tint(MedicationTheme.purple)
                        .frame(maxWidth: .infinity)
                } else if viewModel.activeMeds.isEmpty {
                    emptyMessage("No current medications.")
                } else {
                    ForEach(viewModel.activeMeds, id: \.id) { med in
                        medicationRow(
                            title: med.medName,
                            subtitle: "Start Date: \(med.startDate)",
                            buttonTitle: "Edit",
                            destination: AddMedicationView(
                                medication: med,
                                isViewOnly: false
                            )
                        )
                    }
                }

                Divider()
                    .padding(.vertical, 4)

                Text("Discontinued Medications")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(MedicationTheme.purple)

                if viewModel.isLoading {
                    EmptyView()
                } else if viewModel.pastMeds.isEmpty {
                    emptyMessage("No discontinued medications.")
                } else {
                    ForEach(viewModel.pastMeds, id: \.id) { med in
                        medicationRow(
                            title: med.medName,
                            subtitle: "Discontinued Date: \(med.endDate)",
                            buttonTitle: "View",
                            destination: AddMedicationView(
                                medication: med,
                                isViewOnly: true
                            )
                        )
                    }
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("Medications")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMedications()
        }
        .preferredColorScheme(.light)
    }

    private func emptyMessage(_ message: String) -> some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(MedicationTheme.lightLavender)
            .cornerRadius(12)
    }

    private func medicationRow<Destination: View>(
        title: String,
        subtitle: String,
        buttonTitle: String,
        destination: Destination
    ) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            NavigationLink {
                destination
            } label: {
                Text(buttonTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(MedicationTheme.purple)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(MedicationTheme.purple, lineWidth: 1.5)
                    )
            }
        }
        .padding()
        .background(MedicationTheme.lightLavender)
        .cornerRadius(12)
    }
}

enum MedicationTheme {
    static let purple = Color(
        red: 91.0 / 255.0,
        green: 58.0 / 255.0,
        blue: 130.0 / 255.0
    )

    static let coral = Color(
        red: 255.0 / 255.0,
        green: 143.0 / 255.0,
        blue: 112.0 / 255.0
    )

    static let lightLavender = Color(
        red: 245.0 / 255.0,
        green: 241.0 / 255.0,
        blue: 249.0 / 255.0
    )
}
