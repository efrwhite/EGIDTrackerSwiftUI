//
//  CustomResourcesView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct CustomResourcesView: View {
    
    @StateObject private var viewModel = CustomResourcesViewModel()
    @State private var showAddEdit = false
    @State private var editingResource: CustomResourceItem?
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Button("Add") {
                    editingResource = nil
                    showAddEdit = true
                }
                .font(.title3)
                
                Spacer()
            }
            
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.resources.isEmpty {
                Spacer()
                Text("No custom resources yet.")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List(viewModel.resources) { resource in
                    HStack {
                        Button {
                            openURL(resource.url)
                        } label: {
                            Text(resource.title)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Button("Edit") {
                            editingResource = resource
                            showAddEdit = true
                        }
                        .foregroundColor(Color("PrimaryColor"))
                    }
                }
                .listStyle(.plain)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .navigationTitle("Custom Resources")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadResources()
        }
        .sheet(isPresented: $showAddEdit) {
            AddCustomResourceView(
                viewModel: viewModel,
                existingResource: editingResource
            )
        }
    }
    
    private func openURL(_ value: String) {
        guard let url = URL(string: value) else { return }
        UIApplication.shared.open(url)
    }
}
