//
//  AddCustomResourceView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct AddCustomResourceView: View {
    
    @ObservedObject var viewModel: CustomResourcesViewModel
    let existingResource: CustomResourceItem?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var url = ""
    
    private var isEditing: Bool {
        existingResource != nil
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                TextField("Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                TextField("URL", text: $url)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                Button {
                    Task {
                        await viewModel.saveResource(
                            id: existingResource?.id,
                            title: title,
                            url: normalizedURL(url),
                            userId: existingResource?.userId ?? ""
                        )
                        dismiss()
                    }
                } label: {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                if let existingResource {
                    Button("Delete", role: .destructive) {
                        Task {
                            await viewModel.deleteResource(existingResource)
                            dismiss()
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(isEditing ? "Edit Resource" : "Add Resource")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                title = existingResource?.title ?? ""
                url = existingResource?.url ?? ""
            }
        }
    }
    
    private func normalizedURL(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.lowercased().hasPrefix("http://") ||
            trimmed.lowercased().hasPrefix("https://") {
            return trimmed
        }
        
        return "https://\(trimmed)"
    }
}
