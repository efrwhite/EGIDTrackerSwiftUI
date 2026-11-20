//
//  AccidentalExposure.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//


import SwiftUI

struct AccidentalExposureView: View {

    @StateObject private var viewModel = AccidentalExposureViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                // Screen Header
                Text("Accidental Exposure")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    .background(ExposureTheme.purple)

                // Exposure Form
                VStack(alignment: .leading, spacing: 18) {

                    Text("Report an exposure")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(ExposureTheme.darkPurple)

                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.headline)
                            .foregroundColor(ExposureTheme.darkPurple)

                        DatePicker(
                            "",
                            selection: $viewModel.selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(ExposureTheme.purple)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    ExposureTheme.purple,
                                    lineWidth: 1.3
                                )
                        )
                    }

                    // Description / Item Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(ExposureTheme.darkPurple)

                        TextField(
                            "Item name",
                            text: $viewModel.itemName
                        )
                        .font(.body)
                        .padding(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    ExposureTheme.purple.opacity(0.8),
                                    lineWidth: 1.3
                                )
                        )
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(ExposureTheme.darkPurple)

                        TextEditor(text: $viewModel.description)
                            .frame(minHeight: 130)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        ExposureTheme.purple,
                                        lineWidth: 1.3
                                    )
                            )
                    }

                    // Add Exposure Button
                    Button {
                        viewModel.saveItem()
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(ExposureTheme.coral)
                            } else {
                                Text("Add exposure")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(ExposureTheme.coral)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ExposureTheme.purple)
                        .cornerRadius(16)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.top, 6)
                }
                .padding(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            ExposureTheme.purple.opacity(0.7),
                            lineWidth: 1.2
                        )
                )
                .cornerRadius(16)
                .padding(.horizontal, 12)

                // History
                VStack(alignment: .leading, spacing: 10) {

                    Text("History")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(ExposureTheme.darkPurple)

                    if viewModel.isLoading && viewModel.history.isEmpty {
                        ProgressView()
                            .tint(ExposureTheme.purple)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if viewModel.history.isEmpty {
                        Text("No exposures reported")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 35)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        ExposureTheme.purple,
                                        style: StrokeStyle(
                                            lineWidth: 1.3,
                                            dash: [3, 3]
                                        )
                                    )
                            )
                            .cornerRadius(16)
                    } else {
                        ForEach(viewModel.history, id: \.id) { item in
                            VStack(alignment: .leading, spacing: 8) {

                                Text(item.itemName)
                                    .font(.headline)
                                    .foregroundColor(ExposureTheme.darkPurple)

                                Text("Date: \(item.date)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                if !item.description.isEmpty {
                                    Text(item.description)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(ExposureTheme.lightPurple)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 12)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadHistory()
        }
        .preferredColorScheme(.light)
    }
}

// MARK: - Colors

private enum ExposureTheme {

    static let purple = Color(
        red: 91.0 / 255.0,
        green: 58.0 / 255.0,
        blue: 130.0 / 255.0
    )

    static let darkPurple = Color(
        red: 69.0 / 255.0,
        green: 43.0 / 255.0,
        blue: 94.0 / 255.0
    )

    static let coral = Color(
        red: 255.0 / 255.0,
        green: 143.0 / 255.0,
        blue: 112.0 / 255.0
    )

    static let lightPurple = Color(
        red: 245.0 / 255.0,
        green: 241.0 / 255.0,
        blue: 249.0 / 255.0
    )
}

