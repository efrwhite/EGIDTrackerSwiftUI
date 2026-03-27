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
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Report New Accidental Exposure")
                    .font(.title2)
                    .bold()
                
                DatePicker(
                    "Date",
                    selection: $viewModel.selectedDate,
                    displayedComponents: .date
                )
                
                TextField("Item Name", text: $viewModel.itemName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Description", text: $viewModel.description, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(4, reservesSpace: true)
                
                Button {
                    viewModel.saveItem()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Save")
                            .bold()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Divider()
                
                Text("History")
                    .font(.title2)
                    .bold()
                
                if viewModel.history.isEmpty && !viewModel.isLoading {
                    Text("No accidental exposures recorded.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.history, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.itemName)
                                .font(.headline)
                            
                            if !item.description.isEmpty {
                                Text(item.description)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Text(item.date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .navigationTitle("Accidental Exposure")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadHistory()
        }
    }
}
