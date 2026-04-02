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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                HStack {
                    Text("Quality of Life")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink("Results") {
                        ResultsView(source: .qol)
                    }
                    .buttonStyle(.bordered)
                }
                
                keySection
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Visit Date")
                        .font(.headline)
                    
                    DatePicker(
                        "",
                        selection: $viewModel.visitDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                questionSections
                
                Text("Total Score: \(viewModel.totalScore)")
                    .font(.headline)
                
                Button {
                    Task {
                        await viewModel.save()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Save")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .navigationTitle("Quality of Life")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                goToResults = true
            }
        }
        .background(
            NavigationLink(destination: ResultsView(source: .qol), isActive: $goToResults) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    private var keySection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Symptom Key:")
                .font(.headline)
            Text("0 - never a problem")
            Text("1 - almost never a problem")
            Text("2 - sometimes a problem")
            Text("3 - often a problem")
            Text("4 - almost always a problem")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    private var questionSections: some View {
        VStack(spacing: 16) {
            var answerIndex = 0
            
            ForEach(Array(viewModel.sectionedQuestions.enumerated()), id: \.offset) { _, section in
                VStack(alignment: .leading, spacing: 12) {
                    Text(section.title)
                        .font(.title3)
                        .bold()
                    
                    ForEach(Array(section.questions.enumerated()), id: \.offset) { questionOffset, question in
                        let currentIndex = viewModel.sectionedQuestions
                            .prefix { $0.title != section.title }
                            .flatMap { $0.questions }
                            .count + questionOffset
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(question)
                                .font(.headline)
                            
                            TextField("0 – 4", text: $viewModel.answers[currentIndex])
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}
