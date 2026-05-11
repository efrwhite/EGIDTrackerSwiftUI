//
//  CustomResourcesView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import Foundation
import Combine

@MainActor
final class CustomResourcesViewModel: ObservableObject {
    
    @Published var resources: [CustomResourceItem] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let dbService = FirebaseDBService()
    
    func loadResources() async {
        isLoading = true
        errorMessage = nil
        
        do {
            resources = try await dbService.fetchCustomResourcesForCurrentUser()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func saveResource(id: String?, title: String, url: String, userId: String = "") async {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanTitle.isEmpty, !cleanURL.isEmpty else {
            errorMessage = "Please enter both a title and URL."
            return
        }
        
        do {
            if let id {
                let item = CustomResourceItem(
                    id: id,
                    title: cleanTitle,
                    url: cleanURL,
                    userId: userId
                )
                try await dbService.updateCustomResource(item)
            } else {
                try await dbService.addCustomResource(title: cleanTitle, url: cleanURL)
            }
            
            await loadResources()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteResource(_ resource: CustomResourceItem) async {
        guard let id = resource.id else { return }
        
        do {
            try await dbService.deleteCustomResource(resourceId: id)
            await loadResources()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
