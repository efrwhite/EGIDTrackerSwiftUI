//
//  DocumentsViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/27/26.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Combine

@MainActor
final class DocumentsViewModel: ObservableObject {
    
    @Published var documents: [StoredDocument] = []
    @Published var errorMessage: String?
    
    @Published var showingRenameAlert = false
    @Published var renameText = ""
    @Published var selectedDocumentForRename: StoredDocument?
    
    private let dbService = FirebaseDBService()
    private let storageKey = "StoredDocuments"
    
    // MARK: - Load
    
    func loadDocuments() {
        guard let childId = dbService.getCurrentChildId() else {
            documents = []
            return
        }
        
        let allDocs = readAllDocuments()
        documents = allDocs
            .filter { $0.childId == childId }
            .sorted { $0.date > $1.date }
    }
    
    // MARK: - Add
    
    func importPhotoData(_ data: Data, fileName: String = "photo.jpg") {
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child is currently selected."
            return
        }
        
        do {
            let fileManager = FileManager.default
            let docsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = docsDirectory.appendingPathComponent("\(UUID().uuidString)_\(fileName)")
            
            try data.write(to: destinationURL)
            
            let doc = StoredDocument(
                id: UUID(),
                childId: childId,
                name: fileName,
                filePath: destinationURL.path,
                type: "image/jpeg",
                size: Int64(data.count),
                date: Date()
            )
            
            saveDocument(doc)
            loadDocuments()
        } catch {
            errorMessage = "Failed to import photo: \(error.localizedDescription)"
        }
    }
    
    func importDocument(from url: URL) {
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child is currently selected."
            return
        }
        
        do {
            let didAccess = url.startAccessingSecurityScopedResource()
            defer {
                if didAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            let fileManager = FileManager.default
            let docsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = url.lastPathComponent
            let destinationURL = docsDirectory.appendingPathComponent("\(UUID().uuidString)_\(fileName)")
            
            try fileManager.copyItem(at: url, to: destinationURL)
            
            let values = try destinationURL.resourceValues(forKeys: [.fileSizeKey, .contentTypeKey])
            let size = Int64(values.fileSize ?? 0)
            let type = values.contentType?.preferredMIMEType ?? "application/octet-stream"
            
            let doc = StoredDocument(
                id: UUID(),
                childId: childId,
                name: fileName,
                filePath: destinationURL.path,
                type: type,
                size: size,
                date: Date()
            )
            
            saveDocument(doc)
            loadDocuments()
        } catch {
            errorMessage = "Failed to import document: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Open
    
    func fileURL(for document: StoredDocument) -> URL {
        URL(fileURLWithPath: document.filePath)
    }
    
    // MARK: - Rename
    
    func beginRename(_ document: StoredDocument) {
        selectedDocumentForRename = document
        renameText = document.name
        showingRenameAlert = true
    }
    
    func confirmRename() {
        guard let document = selectedDocumentForRename else { return }
        let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            errorMessage = "Name cannot be empty."
            return
        }
        
        var allDocs = readAllDocuments()
        guard let index = allDocs.firstIndex(where: { $0.id == document.id }) else { return }
        
        allDocs[index].name = trimmed
        writeAllDocuments(allDocs)
        loadDocuments()
        
        selectedDocumentForRename = nil
        renameText = ""
    }
    
    // MARK: - Delete
    
    func deleteDocument(_ document: StoredDocument) {
        do {
            let url = URL(fileURLWithPath: document.filePath)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            errorMessage = "Failed to remove file from storage."
        }
        
        var allDocs = readAllDocuments()
        allDocs.removeAll { $0.id == document.id }
        writeAllDocuments(allDocs)
        loadDocuments()
    }
    
    // MARK: - Storage
    
    private func saveDocument(_ document: StoredDocument) {
        var allDocs = readAllDocuments()
        allDocs.append(document)
        writeAllDocuments(allDocs)
    }
    
    private func readAllDocuments() -> [StoredDocument] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([StoredDocument].self, from: data)
        } catch {
            return []
        }
    }
    
    private func writeAllDocuments(_ docs: [StoredDocument]) {
        do {
            let data = try JSONEncoder().encode(docs)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            errorMessage = "Failed to save documents."
        }
    }
}
