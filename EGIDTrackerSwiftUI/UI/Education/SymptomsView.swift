//
//  SymptomsView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct SymptomsView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Text(EducationText.symptomsEoE)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                Text(EducationText.eoeSymptoms)
                    .educationBodyStyle()
                
                Text(EducationText.eoeSymptoms2)
                    .educationBodyStyle()
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color("PrimaryBackground"))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension Text {
    func educationBodyStyle() -> some View {
        self
            .font(.body)
            .foregroundColor(Color("PrimaryColor"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
