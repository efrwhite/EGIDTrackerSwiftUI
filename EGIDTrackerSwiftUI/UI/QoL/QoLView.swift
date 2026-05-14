//
//  QoLView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import SwiftUI

struct QoLView: View {
    
    @StateObject private var viewModel = QoLViewModel()
    @State private var goToResults = false
    @State private var activeSectionIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            TabView(selection: $activeSectionIndex) {
                ForEach(Array(viewModel.sectionedQuestions.enumerated()), id: \.offset) { sIndex, section in
                    sectionPage(section: section, sIndex: sIndex)
                        .tag(sIndex)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            footerView
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Quality of Life")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded { goToResults = true }
        }
        .background(
            NavigationLink(destination: ResultsView(source: .qol), isActive: $goToResults) {
                EmptyView()
            }
            .hidden()
        )
    }
    private var headerView: some View {
        VStack(spacing: 12) {
            let total = viewModel.sectionedQuestions.count
            let progress = Double(activeSectionIndex + 1) / Double(total)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Section \(activeSectionIndex + 1) of \(total)")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(Color("SecondaryColor"))
                }
                ProgressView(value: progress)
                    .tint(Color("SecondaryColor"))
            }
            
            Divider()
            HStack {
                Text("Visit Date")
                    .font(.headline)
                Spacer()
                DatePicker("", selection: $viewModel.visitDate, displayedComponents: .date)
                    .labelsHidden()
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    private func sectionPage(section: (title: String, questions: [String]), sIndex: Int) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(section.title)
                                    .font(.title2.bold())
                                Text("0 = Never a problem, 4 = Almost always")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top)
                
                ForEach(Array(section.questions.enumerated()), id: \.offset) { questionOffset, question in
                    let currentIndex = viewModel.sectionedQuestions
                        .prefix { $0.title != section.title }
                        .flatMap { $0.questions }
                        .count + questionOffset
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(question)
                            .font(.headline)
                        HStack {
                            ForEach(0...4, id: \.self) { score in
                                scoreCircleButton(score: score, index: currentIndex)
                                if score < 4 { Spacer() }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
        }
    }
    private func scoreCircleButton(score: Int, index: Int) -> some View {
        Button {
            viewModel.answers[index] = "\(score)"
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
            Text("\(score)")
                .font(.subheadline.bold())
                .frame(width: 55, height: 55)
                .background(viewModel.answers[index] == "\(score)" ? Color("SecondaryColor") : Color(.systemGray6))
                .foregroundColor(viewModel.answers[index] == "\(score)" ? .white : .primary)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
    private var footerView: some View {
        VStack(spacing: 0) {
            Divider()
            
            VStack(spacing: 12) {
                HStack {
                    Text("Total Score: \(viewModel.totalScore)")
                        .font(.headline)
                    
                    Spacer()
                    if activeSectionIndex > 0 {
                        Button {
                            withAnimation { activeSectionIndex -= 1 }
                        } label: {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                if activeSectionIndex < viewModel.sectionedQuestions.count - 1 {
                    Button {
                        withAnimation { activeSectionIndex += 1 }
                    } label: {
                        Text("Next Section")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("SecondaryColor"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Button {
                        Task { await viewModel.save() }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Save Assessment")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
}
#Preview {
    QoLView()
}
