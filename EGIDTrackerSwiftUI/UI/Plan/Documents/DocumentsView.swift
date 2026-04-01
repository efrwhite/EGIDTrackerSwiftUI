//
//  Documents.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI
import UniformTypeIdentifiers
import PhotosUI
import QuickLook

struct DocumentsView: View {

    @StateObject private var viewModel = DocumentsViewModel()

    @State private var showImportPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showPhotoPicker = false

    @State private var showOptions = false
    @State private var previewDocument: StoredDocument?

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Text("Documents")
                    .font(.largeTitle)
                    .bold()

                Spacer()

                Button("Add") {
                    showOptions = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            if viewModel.documents.isEmpty {
                Spacer()
                Text("No documents yet.")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.documents) { document in
                        HStack {
                            Button {
                                previewDocument = document
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(document.fullDisplayName)
                                        .foregroundColor(.primary)

                                    Text(document.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.plain)

                            Spacer()

                            Menu("Edit") {
                                Button("Rename") {
                                    viewModel.beginRename(document)
                                }

                                Button("Delete", role: .destructive) {
                                    viewModel.deleteDocument(document)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Documents")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.loadDocuments()
        }
        .confirmationDialog("Add Document", isPresented: $showOptions, titleVisibility: .visible) {
            Button("Load Document") {
                showImportPicker = true
            }

            Button("Choose Photo") {
                showPhotoPicker = true
            }

            Button("Cancel", role: .cancel) { }
        }
        .fileImporter(
            isPresented: $showImportPicker,
            allowedContentTypes: [.item],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    viewModel.importDocument(from: url)
                }
            case .failure(let error):
                viewModel.errorMessage = "Import failed: \(error.localizedDescription)"
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { _, item in
            guard let item else { return }

            Task {
                await viewModel.importPhoto(from: item)
                selectedPhotoItem = nil
            }
        }
        .alert("Rename Document", isPresented: $viewModel.showingRenameAlert) {
            TextField("Document Name", text: $viewModel.renameText)

            Button("Rename") {
                viewModel.confirmRename()
            }

            Button("Cancel", role: .cancel) { }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(item: $previewDocument) { document in
            DocumentPreviewController(
                url: viewModel.fileURL(for: document),
                title: document.fullDisplayName
            )
        }
    }
}

private extension StoredDocument {
    var fullDisplayName: String {
        if originalExtension.isEmpty {
            return displayName
        }
        return "\(displayName).\(originalExtension)"
    }
}
