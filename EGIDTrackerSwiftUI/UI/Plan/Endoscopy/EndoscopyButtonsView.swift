//
//  EndoscopyButtonsView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/30/26.
//

import SwiftUI

enum EndoscopySection: String {
    case eoe
    case colon
    case stomach
    case duodenum
}

struct EndoscopyButtonsView: View {
    
    let startDate: Date?
    let endDate: Date?
    
    var body: some View {
        VStack(spacing: 16) {
            
            NavigationLink("EoE") {
                ReportView(source: .endoscopy, section: .eoe, startDate: startDate, endDate: endDate)
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink("Colon") {
                ReportView(source: .endoscopy, section: .colon, startDate: startDate, endDate: endDate)
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink("Stomach") {
                ReportView(source: .endoscopy, section: .stomach, startDate: startDate, endDate: endDate)
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink("Duodenum") {
                ReportView(source: .endoscopy, section: .duodenum, startDate: startDate, endDate: endDate)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Endoscopy Reports")
    }
}
