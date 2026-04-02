//
//  DocumentPreviewController.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/27/26.
//

import SwiftUI
import QuickLook

struct DocumentPreviewController: UIViewControllerRepresentable {
    let url: URL
    let title: String

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url, title: title)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) { }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        let previewItem: PreviewItem

        init(url: URL, title: String) {
            self.previewItem = PreviewItem(url: url, title: title)
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            previewItem
        }
    }

    final class PreviewItem: NSObject, QLPreviewItem {
        let previewItemURL: URL?
        let previewItemTitle: String?

        init(url: URL, title: String) {
            self.previewItemURL = url
            self.previewItemTitle = title
        }
    }
}
