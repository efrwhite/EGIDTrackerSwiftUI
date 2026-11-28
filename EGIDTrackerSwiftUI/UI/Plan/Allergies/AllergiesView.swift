//
//  AllergiesView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//


import SwiftUI

struct AllergiesView: View {

    @StateObject private var viewModel = AllergiesViewModel()

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

    var body: some View {

        VStack(spacing: 0) {

            // Header
            HStack {
                Text("Allergens")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 25)
            .frame(height: 67)
            .background(purple)

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    // Current Allergens
                    VStack(alignment: .leading, spacing: 14) {

                        HStack {
                            Text("Current Allergens")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(purple)

                            Spacer()

                            NavigationLink {
                                AddAllergiesView()
                            } label: {
                                Text("Add Allergen")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(coral)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(purple)
                                    .clipShape(RoundedRectangle(cornerRadius: 9))
                            }
                        }

                        if viewModel.currentAllergies.isEmpty {
                            emptyMessage("No current allergens.")
                        } else {
                            ForEach(viewModel.currentAllergies, id: \.id) { allergen in

                                allergyRow(
                                    allergen: allergen,
                                    buttonTitle: "Edit",
                                    isViewOnly: false
                                )
                            }
                        }
                    }

                    Divider()

                    // Discontinued Allergens
                    VStack(alignment: .leading, spacing: 14) {

                        Text("Discontinued Allergens")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(purple)

                        if viewModel.pastAllergies.isEmpty {
                            emptyMessage("No discontinued allergens.")
                        } else {
                            ForEach(viewModel.pastAllergies, id: \.id) { allergen in

                                allergyRow(
                                    allergen: allergen,
                                    buttonTitle: "View",
                                    isViewOnly: true
                                )
                            }
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .tint(purple)
                            .frame(maxWidth: .infinity)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(20)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
        .task {
            await viewModel.loadAllergies()
        }
    }

    // MARK: - Allergy Row

    private func allergyRow(
        allergen: AllergenItem,
        buttonTitle: String,
        isViewOnly: Bool
    ) -> some View {

        HStack(spacing: 10) {

            VStack(alignment: .leading, spacing: 5) {

                Text(allergen.allergenName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Text(allergen.igE ? "IgE Allergen" : "Non-IgE Allergen")
                    .font(.system(size: 13))
                    .foregroundColor(purple)
            }

            Spacer()

            NavigationLink {
                AddAllergiesView(
                    allergenId: allergen.id,
                    isViewOnly: isViewOnly
                )
            } label: {
                Text(buttonTitle)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(coral)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(purple)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(purple.opacity(0.5), lineWidth: 1)
        }
    }

    // MARK: - Empty Message

    private func emptyMessage(_ message: String) -> some View {
        Text(message)
            .font(.system(size: 14))
            .foregroundColor(.secondary)
            .padding(.vertical, 8)
    }
}
