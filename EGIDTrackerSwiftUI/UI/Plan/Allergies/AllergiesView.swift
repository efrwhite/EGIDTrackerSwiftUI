//
//  AllergiesView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI

struct AllergiesView: View {
    
    @StateObject private var viewModel = AllergiesViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("Current Allergens")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink("Add") {
                        AddAllergiesView()
                    }
                }
                
                if viewModel.currentAllergies.isEmpty {
                    Text("No current allergens.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.currentAllergies, id: \.id) { allergen in
                        allergyRow(
                            name: "\(allergen.allergenName), \(allergen.igE ? "IgE Allergen" : "Non-IgE Allergen")",
                            buttonTitle: "Edit",
                            destination: AddAllergiesView(allergenId: allergen.id, isViewOnly: false)
                        )
                    }
                }
                
                Divider()
                
                Text("Discontinued Allergens")
                    .font(.title2)
                    .bold()
                
                if viewModel.pastAllergies.isEmpty {
                    Text("No discontinued allergens.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.pastAllergies, id: \.id) { allergen in
                        allergyRow(
                            name: "\(allergen.allergenName), \(allergen.igE ? "IgE Allergen" : "Non-IgE Allergen")",
                            buttonTitle: "View",
                            destination: AddAllergiesView(allergenId: allergen.id, isViewOnly: true)
                        )
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                
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
            await viewModel.loadAllergies()
        }
    }
    
    @ViewBuilder
    private func allergyRow<Destination: View>(
        name: String,
        buttonTitle: String,
        destination: Destination
    ) -> some View {
        HStack {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
