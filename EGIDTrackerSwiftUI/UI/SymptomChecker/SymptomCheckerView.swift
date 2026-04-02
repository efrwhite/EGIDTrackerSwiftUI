//
//  SymptomCheckerView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import SwiftUI

struct SymptomCheckerView: View {
    
    @StateObject private var viewModel = SymptomCheckerViewModel()
    @State private var goToResults = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                HStack {
                    Text("Symptom Score")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink("Results") {
                        ResultsView(source: .symptomChecker)
                    }
                    .buttonStyle(.bordered)
                }
                
                keySection
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Date of Quiz")
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
                
                ForEach(Array(viewModel.numericQuestions.enumerated()), id: \.offset) { index, question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.headline)
                        
                        TextField("0 – 4", text: $viewModel.numericAnswers[index])
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                
                ForEach(Array(viewModel.yesNoQuestions.enumerated()), id: \.offset) { index, question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.headline)
                        
                        Toggle(isOn: $viewModel.yesNoAnswers[index]) {
                            Text(viewModel.yesNoAnswers[index] ? "Y" : "N")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                
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
        .navigationTitle("Symptom Score")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                goToResults = true
            }
        }
        .background(
            NavigationLink(destination: ResultsView(source: .symptomChecker), isActive: $goToResults) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    private var keySection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Symptom Key:")
                .font(.headline)
            Text("0 - None")
            Text("1 - Mild")
            Text("2 - Moderate")
            Text("3 - Severe")
            Text("4 - Worst")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
