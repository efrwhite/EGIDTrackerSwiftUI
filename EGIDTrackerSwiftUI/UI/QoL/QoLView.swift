//
//  QoLView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//


import SwiftUI
import UIKit

struct QoLView: View {
    @StateObject private var viewModel = QoLViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var goToResults = false

    private let purple = Color(red: 91.0 / 255.0, green: 58.0 / 255.0, blue: 130.0 / 255.0)
    private let coral = Color(red: 255.0 / 255.0, green: 143.0 / 255.0, blue: 112.0 / 255.0)

    var body: some View {
        VStack(spacing: 0) {
            headerView

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    frequencyLegend
                    visitDateField

                    ForEach(viewModel.sectionedQuestions.indices, id: \.self) { sectionIndex in
                        sectionView(sectionIndex: sectionIndex)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 30)
            }
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            footerView
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
        .background {
            NavigationLink(
                destination: ResultsView(source: .qol),
                isActive: $goToResults
            ) {
                EmptyView()
            }
            .hidden()
        }
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                goToResults = true
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
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

            Text("Quality of life")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Button {
                goToResults = true
            } label: {
                Text("Results")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(coral)
                    .underline()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 134, alignment: .bottom)
        .background(purple)
    }

    // MARK: - Frequency Legend

    private var frequencyLegend: some View {
        Text("0: never    1: almost never    2: sometimes    3: often    4: almost always")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(purple)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(purple, style: StrokeStyle(lineWidth: 1.3, dash: [2, 2]))
            }
    }

    // MARK: - Visit Date

    private var visitDateField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Visit Date")

            DatePicker(
                "",
                selection: $viewModel.visitDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .tint(purple)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .frame(height: 58)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(purple, lineWidth: 1.3)
            }
        }
    }

    // MARK: - Question Sections

    private func sectionView(sectionIndex: Int) -> some View {
        let section = viewModel.sectionedQuestions[sectionIndex]
        let startingQuestionIndex = viewModel.sectionedQuestions
            .prefix(sectionIndex)
            .reduce(0) { total, currentSection in
                total + currentSection.questions.count
            }

        return VStack(alignment: .leading, spacing: 22) {
            sectionLabel(section.title)

            ForEach(section.questions.indices, id: \.self) { questionIndex in
                let answerIndex = startingQuestionIndex + questionIndex

                VStack(alignment: .leading, spacing: 12) {
                    Text(section.questions[questionIndex])
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 0) {
                        ForEach(1...5, id: \.self) { displayedValue in
                            scoreButton(
                                displayedValue: displayedValue,
                                answerIndex: answerIndex
                            )

                            if displayedValue < 5 {
                                Spacer(minLength: 4)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 4)
    }

    // MARK: - Score Buttons

    private func scoreButton(displayedValue: Int, answerIndex: Int) -> some View {
        let storedValue = displayedValue - 1
        let isSelected = viewModel.answers[answerIndex] == "\(storedValue)"

        return Button {
            viewModel.answers[answerIndex] = "\(storedValue)"
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
            Text("\(displayedValue)")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 48, height: 48)
                .background(isSelected ? purple : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 17))
                .overlay {
                    RoundedRectangle(cornerRadius: 17)
                        .stroke(purple, lineWidth: 1.3)
                }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Footer

    private var footerView: some View {
        VStack(spacing: 10) {
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
                        Text("Save answers")
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
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(purple)
    }
}

#Preview {
    NavigationStack {
        QoLView()
    }
}
