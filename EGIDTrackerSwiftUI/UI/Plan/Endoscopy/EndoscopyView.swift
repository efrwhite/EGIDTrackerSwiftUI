//
//  EndoscopyView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//


import SwiftUI

struct EndoscopyView: View {
    @StateObject private var viewModel: EndoscopyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var goToResults = false

    private let purple = Color(red: 91.0 / 255.0, green: 58.0 / 255.0, blue: 130.0 / 255.0)
    private let coral = Color(red: 255.0 / 255.0, green: 143.0 / 255.0, blue: 112.0 / 255.0)
    private let fieldText = Color(red: 74.0 / 255.0, green: 57.0 / 255.0, blue: 69.0 / 255.0)

    init(reportId: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: EndoscopyViewModel(reportId: reportId)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    procedureDateField

                    HStack(alignment: .top, spacing: 18) {
                        scoreSection(
                            title: "EoE",
                            fields: [
                                ("Upper:", $viewModel.proximate),
                                ("Middle:", $viewModel.middle),
                                ("Lower:", $viewModel.lower)
                            ]
                        )

                        scoreSection(
                            title: "Colon",
                            fields: [
                                ("Right:", $viewModel.rightColon),
                                ("Middle:", $viewModel.middleColon),
                                ("Left:", $viewModel.leftColon)
                            ]
                        )
                    }

                    largeTextField(title: "Stomach", text: $viewModel.stomach)
                    largeTextField(title: "Duodenum", text: $viewModel.duodenum)
                    notesField
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 24)
            }
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            saveButton
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
        .task {
            await viewModel.loadIfEditing()
        }
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                dismiss()
            }
        }
        .background {
            NavigationLink(
                destination: ResultsView(source: .endoscopy),
                isActive: $goToResults
            ) {
                EmptyView()
            }
            .hidden()
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(purple)
                    .frame(width: 38, height: 38)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Endoscopy results")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Color.clear
                .frame(width: 38, height: 38)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 134, alignment: .bottom)
        .padding(.bottom, 12)
        .background(purple)
    }

    // MARK: - Procedure Date

    private var procedureDateField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Procedure Date")

            DatePicker(
                "",
                selection: $viewModel.date,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .tint(purple)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .frame(height: 58)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(purple, lineWidth: 1.5)
            }
        }
    }

    // MARK: - EoE and Colon Sections

    private func scoreSection(
        title: String,
        fields: [(String, Binding<String>)]
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(purple)

            ForEach(fields.indices, id: \.self) { index in
                HStack(spacing: 5) {
                    Text(fields[index].0)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(fieldText)
                        .frame(width: 43, alignment: .leading)

                    TextField("", text: fields[index].1)
                        .keyboardType(.numberPad)
                        .font(.system(size: 15))
                        .foregroundColor(fieldText)
                        .padding(.horizontal, 8)
                        .frame(height: 34)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule().stroke(purple, lineWidth: 1)
                        }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .frame(height: 144)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(purple, style: StrokeStyle(lineWidth: 1.2, dash: [2, 2]))
        }
    }

    // MARK: - Stomach and Duodenum

    private func largeTextField(
        title: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            sectionLabel(title)

            TextField("", text: text)
                .keyboardType(.numberPad)
                .font(.system(size: 18))
                .foregroundColor(fieldText)
                .padding(.horizontal, 15)
                .frame(height: 58)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(purple, lineWidth: 1.3)
                }
        }
    }

    // MARK: - Notes

    private var notesField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Notes")

            TextEditor(text: $viewModel.notes)
                .font(.system(size: 16))
                .foregroundColor(fieldText)
                .scrollContentBackground(.hidden)
                .padding(8)
                .frame(height: 128)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(purple, lineWidth: 1.3)
                }
        }
    }

    // MARK: - Save

    private var saveButton: some View {
        VStack(spacing: 8) {
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task {
                    await viewModel.save()
                }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView().tint(coral)
                    } else {
                        Text("Save")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(coral)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(purple)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, 38)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(Color.white)
    }

    // MARK: - Shared Label

    private func sectionLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(purple)
    }
}
