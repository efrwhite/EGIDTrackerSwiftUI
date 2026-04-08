//
//  ReportViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/30/26.
//

import Foundation
import Combine

struct ReportPoint: Identifiable {
    let id = UUID()
    let xValue: Double
    let value: Double
    let series: String
}

@MainActor
final class ReportViewModel: ObservableObject {
    
    @Published var points: [ReportPoint] = []
    @Published var xAxisLabels: [String] = []
    @Published var errorMessage: String?
    
    let source: ResultsSource
    let section: EndoscopySection?
    let startDate: Date?
    let endDate: Date?
    
    private let dbService = FirebaseDBService()
    
    init(source: ResultsSource, section: EndoscopySection?, startDate: Date?, endDate: Date?) {
        self.source = source
        self.section = section
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func load() async {
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child selected."
            return
        }
        
        do {
            let endInclusive = endDate.map {
                Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: $0) ?? $0
            }
            
            switch source {
            case .symptomChecker:
                let results = try await dbService.fetchSymptomScoreRows(
                    childId: childId,
                    startDate: startDate,
                    endDate: endInclusive
                )
                
                let sortedResults = results.sorted { $0.date < $1.date }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d/yy"
                xAxisLabels = sortedResults.map { formatter.string(from: $0.date) }
                
                points = sortedResults.enumerated().map { index, result in
                    ReportPoint(
                        xValue: Double(index),
                        value: Double(result.totalScore),
                        series: "Score"
                    )
                }
                
            case .endoscopy:
                guard let section else { return }
                
                let results = try await dbService.fetchEndoscopyResults(
                    childId: childId,
                    startDate: startDate,
                    endDate: endInclusive
                )
                
                let sortedResults = results.sorted { $0.date < $1.date }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d/yy"
                xAxisLabels = sortedResults.map { formatter.string(from: $0.date) }
                
                var newPoints: [ReportPoint] = []
                
                for (index, result) in sortedResults.enumerated() {
                    let baseX = Double(index)
                    
                    switch section {
                    case .eoe:
                        if let value = result.proximate {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Proximate"))
                        }
                        if let value = result.middle {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Middle"))
                        }
                        if let value = result.lower {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Lower"))
                        }
                        
                    case .colon:
                        if let value = result.rightColon {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Right Colon"))
                        }
                        if let value = result.middleColon {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Middle Colon"))
                        }
                        if let value = result.leftColon {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Left Colon"))
                        }
                        
                    case .stomach:
                        if let value = result.stomach {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Stomach"))
                        }
                        
                    case .duodenum:
                        if let value = result.duodenum {
                            newPoints.append(.init(xValue: baseX, value: Double(value), series: "Duodenum"))
                        }
                    }
                }
                
                points = newPoints
                
            case .qol:
                let results = try await dbService.fetchQoLScoreRows(
                    childId: childId,
                    startDate: startDate,
                    endDate: endInclusive
                )
                
                let sortedResults = results.sorted { $0.date < $1.date }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d/yy"
                xAxisLabels = sortedResults.map { formatter.string(from: $0.date) }
                
                points = sortedResults.enumerated().map { index, result in
                    ReportPoint(
                        xValue: Double(index),
                        value: Double(result.totalScore),
                        series: "Score"
                    )
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
