//
//  JournalView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import SwiftUI

struct JournalView: View {
    
    @StateObject private var viewModel = JournalViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Picker("Category", selection: $viewModel.selectedCategory) {
                ForEach(JournalCategory.allCases) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 170)
            .onChange(of: viewModel.selectedCategory) { _ in
                Task { await viewModel.loadEntries() }
            }
            
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.entries.isEmpty {
                Text("No entries found.")
                    .foregroundStyle(.secondary)
            } else {
                List(viewModel.entries) { entry in
                    journalRow(entry)
                }
                .listStyle(.plain)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadEntries()
        }
    }
    
    @ViewBuilder
    private func journalRow(_ entry: JournalEntry) -> some View {
        switch entry.category {
        case .endoscopy:
            NavigationLink {
                EndoscopyView(reportId: entry.id)
            } label: {
                rowContent(entry)
            }
            
        case .symptomScore:
            NavigationLink {
                ResultsView(source: .symptomChecker)
            } label: {
                rowContent(entry)
            }
            
        case .qualityOfLife:
            NavigationLink {
                ResultsView(source: .qol)
            } label: {
                rowContent(entry)
            }
            
        case .allergies:
            NavigationLink {
                AllergiesView()
            } label: {
                rowContent(entry)
            }
            
        case .medication:
            NavigationLink {
                MedicationsView()
            } label: {
                rowContent(entry)
            }
            
        case .accidentalExposure:
            NavigationLink {
                AccidentalExposureView()
            } label: {
                rowContent(entry)
            }
        }
    }
    
    private func rowContent(_ entry: JournalEntry) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Date: \(entry.date.formatted(date: .abbreviated, time: .omitted))")
                .font(.headline)
            Text("Info: \(entry.info)")
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
    }
}
