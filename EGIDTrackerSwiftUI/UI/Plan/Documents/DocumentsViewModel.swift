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
import PhotosUI
import UIKit
import PDFKit

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

    // MARK: - Add Photo

    func importPhoto(from item: PhotosPickerItem) async {
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child is currently selected."
            return
        }

        do {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                errorMessage = "Failed to load photo data."
                return
            }

            guard let image = UIImage(data: data) else {
                errorMessage = "Selected image could not be read."
                return
            }

            let normalizedImage = image.normalizedImage()

            guard let jpegData = normalizedImage.jpegData(compressionQuality: 0.9) else {
                errorMessage = "Failed to convert photo."
                return
            }

            let docsDirectory = documentsDirectory()
            let storedFileName = "\(UUID().uuidString).jpg"
            let destinationURL = docsDirectory.appendingPathComponent(storedFileName)

            try jpegData.write(to: destinationURL, options: .atomic)

            let doc = StoredDocument(
                id: UUID(),
                childId: childId,
                displayName: "Photo",
                storedFileName: storedFileName,
                originalExtension: "jpg",
                type: "image/jpeg",
                size: Int64(jpegData.count),
                date: Date()
            )

            saveDocument(doc)
            loadDocuments()
        } catch {
            errorMessage = "Failed to import photo: \(error.localizedDescription)"
        }
    }

    // MARK: - Add Document

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
            let docsDirectory = documentsDirectory()

            let originalExtension = url.pathExtension
            let baseDisplayName = url.deletingPathExtension().lastPathComponent

            let storedFileName: String
            if originalExtension.isEmpty {
                storedFileName = UUID().uuidString
            } else {
                storedFileName = "\(UUID().uuidString).\(originalExtension)"
            }

            let destinationURL = docsDirectory.appendingPathComponent(storedFileName)

            if originalExtension.lowercased() == "pdf" {
                try normalizeAndCopyPDF(from: url, to: destinationURL)
            } else {
                try fileManager.copyItem(at: url, to: destinationURL)
            }

            let values = try destinationURL.resourceValues(forKeys: [.fileSizeKey, .contentTypeKey])
            let size = Int64(values.fileSize ?? 0)
            let type = values.contentType?.preferredMIMEType ?? "application/octet-stream"

            let doc = StoredDocument(
                id: UUID(),
                childId: childId,
                displayName: baseDisplayName,
                storedFileName: storedFileName,
                originalExtension: originalExtension,
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
        documentsDirectory().appendingPathComponent(document.storedFileName)
    }

    // MARK: - Rename

    func beginRename(_ document: StoredDocument) {
        selectedDocumentForRename = document
        renameText = document.displayName
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

        allDocs[index].displayName = trimmed
        writeAllDocuments(allDocs)
        loadDocuments()

        selectedDocumentForRename = nil
        renameText = ""
    }

    // MARK: - Delete

    func deleteDocument(_ document: StoredDocument) {
        do {
            let url = fileURL(for: document)
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

        let decoder = JSONDecoder()

        if let docs = try? decoder.decode([StoredDocument].self, from: data) {
            return docs.filter { fileExists(for: $0) }
        }

        if let legacyDocs = try? decoder.decode([LegacyStoredDocument].self, from: data) {
            let migrated = migrateLegacyDocuments(legacyDocs)
            writeAllDocuments(migrated)
            return migrated
        }

        return []
    }

    private func writeAllDocuments(_ docs: [StoredDocument]) {
        do {
            let data = try JSONEncoder().encode(docs)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            errorMessage = "Failed to save documents."
        }
    }

    // MARK: - Helpers

    private func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    private func fileExists(for document: StoredDocument) -> Bool {
        let url = fileURL(for: document)
        return FileManager.default.fileExists(atPath: url.path)
    }

    private func migrateLegacyDocuments(_ legacyDocs: [LegacyStoredDocument]) -> [StoredDocument] {
        let fileManager = FileManager.default
        let docsDirectory = documentsDirectory()

        return legacyDocs.compactMap { legacy in
            let oldURL = URL(fileURLWithPath: legacy.filePath)
            guard fileManager.fileExists(atPath: oldURL.path) else {
                return nil
            }

            let ext = oldURL.pathExtension.isEmpty
                ? (legacy.name as NSString).pathExtension
                : oldURL.pathExtension

            let baseNameFromName = (legacy.name as NSString).deletingPathExtension
            let displayName = baseNameFromName.isEmpty ? legacy.name : baseNameFromName

            let storedFileName: String
            if ext.isEmpty {
                storedFileName = UUID().uuidString
            } else {
                storedFileName = "\(UUID().uuidString).\(ext)"
            }

            let newURL = docsDirectory.appendingPathComponent(storedFileName)

            do {
                if oldURL.path != newURL.path {
                    try? fileManager.copyItem(at: oldURL, to: newURL)
                }

                return StoredDocument(
                    id: legacy.id,
                    childId: legacy.childId,
                    displayName: displayName,
                    storedFileName: storedFileName,
                    originalExtension: ext,
                    type: legacy.type,
                    size: legacy.size,
                    date: legacy.date
                )
            } catch {
                return nil
            }
        }
    }
    
    private func normalizeAndCopyPDF(from sourceURL: URL, to destinationURL: URL) throws {
        guard let pdfDocument = PDFDocument(url: sourceURL) else {
            throw NSError(domain: "DocumentsViewModel", code: 1001, userInfo: [
                NSLocalizedDescriptionKey: "Could not read PDF."
            ])
        }

        let normalizedDocument = PDFDocument()

        for index in 0..<pdfDocument.pageCount {
            guard let originalPage = pdfDocument.page(at: index) else { continue }

            let normalizedPage = try makeNormalizedPDFPage(from: originalPage)
            normalizedDocument.insert(normalizedPage, at: normalizedDocument.pageCount)
        }

        guard normalizedDocument.write(to: destinationURL) else {
            throw NSError(domain: "DocumentsViewModel", code: 1002, userInfo: [
                NSLocalizedDescriptionKey: "Could not save normalized PDF."
            ])
        }
    }

    private func makeNormalizedPDFPage(from page: PDFPage) throws -> PDFPage {
        let bounds = page.bounds(for: .mediaBox)
        let rotation = page.rotation

        let renderer = UIGraphicsPDFRenderer(bounds: bounds)
        let data = renderer.pdfData { context in
            context.beginPage()

            guard let cgContext = UIGraphicsGetCurrentContext() else { return }

            switch rotation {
            case 90:
                cgContext.translateBy(x: bounds.width, y: 0)
                cgContext.rotate(by: .pi / 2)
            case 180:
                cgContext.translateBy(x: bounds.width, y: bounds.height)
                cgContext.rotate(by: .pi)
            case 270:
                cgContext.translateBy(x: 0, y: bounds.height)
                cgContext.rotate(by: -.pi / 2)
            default:
                break
            }

            page.draw(with: .mediaBox, to: cgContext)
        }

        guard
            let normalizedDoc = PDFDocument(data: data),
            let normalizedPage = normalizedDoc.page(at: 0)
        else {
            throw NSError(domain: "DocumentsViewModel", code: 1003, userInfo: [
                NSLocalizedDescriptionKey: "Could not normalize PDF page."
            ])
        }

        return normalizedPage
    }
}

// MARK: - Legacy Migration Model

private struct LegacyStoredDocument: Codable {
    let id: UUID
    let childId: String
    var name: String
    var filePath: String
    let type: String
    let size: Int64
    let date: Date
}

// MARK: - Image Helper

private extension UIImage {
    func normalizedImage() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalized ?? self
    }
}
