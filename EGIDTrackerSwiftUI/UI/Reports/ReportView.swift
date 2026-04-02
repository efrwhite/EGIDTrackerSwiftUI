//
//  ReportView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/30/26.
//

import SwiftUI
import Charts
import Photos
import UIKit

struct ReportView: View {
    
    @StateObject private var viewModel: ReportViewModel
    
    @State private var exportedPDFURL: URL?
    @State private var showShareSheet = false
    @State private var isExporting = false
    @State private var exportedImage: UIImage?
    @State private var showImageSavedAlert = false
    
    init(source: ResultsSource, section: EndoscopySection?, startDate: Date?, endDate: Date?) {
        _viewModel = StateObject(
            wrappedValue: ReportViewModel(
                source: source,
                section: section,
                startDate: startDate,
                endDate: endDate
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            if viewModel.points.isEmpty {
                Text("No data available.")
                    .foregroundStyle(.secondary)
            } else {
                ReportChartContent(
                    points: viewModel.points,
                    xAxisLabels: viewModel.xAxisLabels
                )
                .frame(height: 340)
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 12)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 12) {
                
                Button {
                    exportPDF()
                } label: {
                    if isExporting {
                        ProgressView()
                    } else {
                        Text("Email / Share PDF")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .disabled(viewModel.points.isEmpty || isExporting)
                
                Button {
                    saveChartToPhotos()
                } label: {
                    Text("Save Chart to Photos")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
                .disabled(viewModel.points.isEmpty || isExporting)
            }
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle(reportTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
        .sheet(isPresented: $showShareSheet) {
            if let exportedPDFURL {
                ActivityView(activityItems: [exportedPDFURL])
            }
        }
        .alert("Saved", isPresented: $showImageSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The chart image was saved to Photos.")
        }
    }
    
    private var reportTitle: String {
        switch viewModel.source {
        case .symptomChecker:
            return "Symptoms Checker Report"
            
        case .endoscopy:
            guard let section = viewModel.section else {
                return "Report"
            }
            
            switch section {
            case .eoe:
                return "EoE Report"
            case .colon:
                return "Colon Report"
            case .stomach:
                return "Stomach Report"
            case .duodenum:
                return "Duodenum Report"
            }
            
        case .qol:
            return "Quality of Life Report"
        }
    }
    
    private func exportPDF() {
        isExporting = true
        
        let exportView = ReportExportContent(
            title: reportTitle,
            points: viewModel.points,
            xAxisLabels: viewModel.xAxisLabels
        )
        .frame(width: 792, height: 612) // landscape letter-style page
        .background(Color.white)
        
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = 2.0
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(reportTitle).pdf")
        let bounds = CGRect(x: 0, y: 0, width: 792, height: 612)
        
        do {
            let pdfRenderer = UIGraphicsPDFRenderer(bounds: bounds)
            try pdfRenderer.writePDF(to: url) { context in
                context.beginPage()
                
                renderer.render { _, renderInContext in
                    renderInContext(context.cgContext)
                }
            }
            
            exportedPDFURL = url
            showShareSheet = true
        } catch {
            viewModel.errorMessage = "Failed to export PDF."
        }
        
        isExporting = false
    }
    
    private func saveChartToPhotos() {
        let exportView = ReportExportContent(
            title: reportTitle,
            points: viewModel.points,
            xAxisLabels: viewModel.xAxisLabels
        )
        .frame(width: 1200, height: 900)
        .background(Color.white)
        
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = 2.0
        
        if let image = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            showImageSavedAlert = true
        } else {
            viewModel.errorMessage = "Failed to create chart image."
        }
    }
}

struct ReportChartContent: View {
    let points: [ReportPoint]
    let xAxisLabels: [String]
    
    var body: some View {
        Chart(points) { point in
            LineMark(
                x: .value("Index", point.xValue),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Series", point.series))
            .lineStyle(StrokeStyle(lineWidth: 3))
            
            PointMark(
                x: .value("Index", point.xValue),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Series", point.series))
            .symbol(by: .value("Series", point.series))
            .symbolSize(90)
        }
        .chartXScale(domain: -0.25...Double(max(xAxisLabels.count - 1, 0)) + 0.25)
        .chartXAxis {
            AxisMarks(values: Array(xAxisLabels.indices)) { value in
                AxisGridLine()
                AxisTick()
                
                if let index = value.as(Int.self),
                   index < xAxisLabels.count {
                    AxisValueLabel {
                        Text(xAxisLabels[index])
                            .font(.caption2)
                            .fixedSize()
                    }
                }
            }
        }
    }
}

struct ReportExportContent: View {
    let title: String
    let points: [ReportPoint]
    let xAxisLabels: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .bold()
            
            Text("Generated: \(Date().formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            ReportChartContent(points: points, xAxisLabels: xAxisLabels)
                .frame(height: 420)
            
            Spacer()
        }
        .padding(30)
        .background(Color.white)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
