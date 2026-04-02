//
//  ResultsView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/30/26.
//

import SwiftUI

struct ResultsView: View {
    
    @StateObject private var viewModel: ResultsViewModel
    @State private var goToButtons = false
    @State private var goToReport = false
    
    @State private var showStartPicker = false
    @State private var showEndPicker = false
    @State private var tempStartDate = Date()
    @State private var tempEndDate = Date()
    
    init(source: ResultsSource) {
        _viewModel = StateObject(wrappedValue: ResultsViewModel(source: source))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack(spacing: 12) {
                
                Button {
                    tempStartDate = viewModel.startDate ?? Date()
                    showStartPicker = true
                } label: {
                    Text(
                        viewModel.startDate?.formatted(date: .numeric, time: .omitted)
                        ?? "Select Start Date"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button {
                    tempEndDate = viewModel.endDate ?? Date()
                    showEndPicker = true
                } label: {
                    Text(
                        viewModel.endDate?.formatted(date: .numeric, time: .omitted)
                        ?? "Select End Date"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            Button("Generate Report") {
                switch viewModel.source {
                case .endoscopy:
                    goToButtons = true
                case .symptomChecker:
                    goToReport = true
                case .qol:
                    goToReport = true
                }
            }
            .buttonStyle(.borderedProminent)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            Group {
                switch viewModel.source {
                case .endoscopy:
                    List(viewModel.endoscopyResults) { result in
                        NavigationLink {
                            EndoscopyView(reportId: result.id)
                        } label: {
                            HStack {
                                Text(result.date.formatted(date: .numeric, time: .omitted))
                                Spacer()
                                Text("\(result.totalScore)")
                            }
                        }
                    }
                    
                case .symptomChecker:
                    List(viewModel.scoreResults) { result in
                        HStack {
                            Text(result.date.formatted(date: .numeric, time: .omitted))
                            Spacer()
                            Text("\(result.totalScore)")
                        }
                    }
                    
                case .qol:
                    List(viewModel.scoreResults) { result in
                        HStack {
                            Text(result.date.formatted(date: .numeric, time: .omitted))
                            Spacer()
                            Text("\(result.totalScore)")
                        }
                    }
                }
            }
            .listStyle(.plain)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            NavigationLink(
                destination: EndoscopyButtonsView(
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate
                ),
                isActive: $goToButtons
            ) {
                EmptyView()
            }
            
            NavigationLink(
                destination: ReportView(
                    source: viewModel.source,
                    section: nil as EndoscopySection?,
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate
                ),
                isActive: $goToReport
            ) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadResults()
        }
        .onChange(of: viewModel.startDate) { _ in
            Task { await viewModel.loadResults() }
        }
        .onChange(of: viewModel.endDate) { _ in
            Task { await viewModel.loadResults() }
        }
        .sheet(isPresented: $showStartPicker) {
            NavigationStack {
                VStack(spacing: 20) {
                    DatePicker("Start Date", selection: $tempStartDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    HStack {
                        Button("Clear", role: .destructive) {
                            viewModel.startDate = nil
                            showStartPicker = false
                        }
                        
                        Spacer()
                        
                        Button("Done") {
                            viewModel.startDate = tempStartDate
                            showStartPicker = false
                        }
                    }
                }
                .padding()
                .navigationTitle("Start Date")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showEndPicker) {
            NavigationStack {
                VStack(spacing: 20) {
                    DatePicker("End Date", selection: $tempEndDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    HStack {
                        Button("Clear", role: .destructive) {
                            viewModel.endDate = nil
                            showEndPicker = false
                        }
                        
                        Spacer()
                        
                        Button("Done") {
                            viewModel.endDate = tempEndDate
                            showEndPicker = false
                        }
                    }
                }
                .padding()
                .navigationTitle("End Date")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
