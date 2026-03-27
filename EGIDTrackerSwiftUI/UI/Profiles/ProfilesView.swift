//
//  ProfilesView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI

struct ProfilesView: View {
    
    @StateObject private var viewModel = ProfilesViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                if let activeChildName = viewModel.activeChildName,
                   !activeChildName.isEmpty {
                    Text("Active: \(activeChildName)")
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Capsule())
                }
                
                HStack {
                    Text("Children")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink("Add Child") {
                        ChildProfileView()
                    }
                }
                
                if viewModel.children.isEmpty {
                    Text("No child profiles yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.children, id: \.id) { child in
                        profileRow(
                            name: child.firstName,
                            onNameTap: {
                                viewModel.selectChild(child)
                            },
                            editDestination: ChildProfileView(childId: child.id)
                        )
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Caregivers")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink("Add Caregiver") {
                        CaregiverProfileView()
                    }
                }
                
                if viewModel.caregivers.isEmpty {
                    Text("No caregiver profiles yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.caregivers, id: \.id) { caregiver in
                        profileRow(
                            name: caregiver.firstName,
                            onNameTap: {},
                            editDestination: CaregiverProfileView(caregiverId: caregiver.id)
                        )
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .navigationTitle("Profiles")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProfiles()
        }
        .onChange(of: viewModel.didSelectChild) { didSelect in
            if didSelect {
                dismiss()
            }
        }
    }
    
    @ViewBuilder
    private func profileRow<Destination: View>(
        name: String,
        onNameTap: @escaping () -> Void,
        editDestination: Destination
    ) -> some View {
        HStack {
            Button(action: onNameTap) {
                Text(name)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            NavigationLink("Edit") {
                editDestination
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
#Preview {
    ProfilesView()
}
