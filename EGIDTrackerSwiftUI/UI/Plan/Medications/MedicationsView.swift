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
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("Current Medications")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink("Add") {
                        AddMedicationView()
                    }
                }
                
                if viewModel.activeMeds.isEmpty {
                    Text("No current medications.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.activeMeds, id: \.id) { med in
                        medicationRow(
                            title: med.medName,
                            subtitle: "Start Date: \(med.startDate)",
                            buttonTitle: "Edit",
                            destination: AddMedicationView(medication: med, isViewOnly: false)
                        )
                    }
                }
                
                Divider()
                
                Text("Discontinued Medications")
                    .font(.title2)
                    .bold()
                
                if viewModel.pastMeds.isEmpty {
                    Text("No discontinued medications.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.pastMeds, id: \.id) { med in
                        medicationRow(
                            title: med.medName,
                            subtitle: "Discontinued Date: \(med.endDate)",
                            buttonTitle: "View",
                            destination: AddMedicationView(medication: med, isViewOnly: true)
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Medications")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMedications()
        }
    }
    
    @ViewBuilder
    private func medicationRow<Destination: View>(
        title: String,
        subtitle: String,
        buttonTitle: String,
        destination: Destination
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
            
            NavigationLink(buttonTitle) {
                destination
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
