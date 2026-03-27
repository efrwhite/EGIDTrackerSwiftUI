//
//  Diet4View.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI

struct Diet4View: View {
    
    private let viewModel = Diet4ViewModel()
    @State private var goToAllergies = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Diet 4:\nDairy, Gluten, & Egg-Free Diet")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(viewModel.diet.subtitle)
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.diet.sections) { section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section.title)
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            ForEach(section.foods, id: \.self) { food in
                                Text(food)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            
            NavigationLink(destination: AllergiesView(), isActive: $goToAllergies) {
                EmptyView()
            }
            
            Button("Allergies") {
                goToAllergies = true
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
        .padding(.top)
        .navigationTitle("Diet 4")
        .navigationBarTitleDisplayMode(.inline)
    }
}
