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
    
    init(reportId: String? = nil) {
        _viewModel = StateObject(wrappedValue: EndoscopyViewModel(reportId: reportId))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                Text(viewModel.isEditing ? "Edit Endoscopy" : "Endoscopy")
                    .font(.title2)
                    .bold()
                
                DatePicker("Procedure Date", selection: $viewModel.date, displayedComponents: .date)
                
                numericField("Upper / Proximate", text: $viewModel.proximate)
                numericField("Middle", text: $viewModel.middle)
                numericField("Lower", text: $viewModel.lower)
                numericField("Stomach", text: $viewModel.stomach)
                numericField("Duodenum", text: $viewModel.duodenum)
                numericField("Right Colon", text: $viewModel.rightColon)
                numericField("Middle Colon", text: $viewModel.middleColon)
                numericField("Left Colon", text: $viewModel.leftColon)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 120)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                        )
                }
                
                Text("Total Score: \(viewModel.totalScore)")
                    .font(.headline)
                
                HStack {
                    Button("Results") {
                        goToResults = true
                    }
                    .buttonStyle(.bordered)
                    
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
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                NavigationLink(destination: ResultsView(source: .endoscopy), isActive: $goToResults) {
                    EmptyView()
                }
            }
            .padding()
        }
        .navigationTitle("Endoscopy")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadIfEditing()
        }
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                dismiss()
            }
        }
    }
    
    @ViewBuilder
    private func numericField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            
            TextField("", text: text)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
        }
    }
}
