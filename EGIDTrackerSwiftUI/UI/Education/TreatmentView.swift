//
//  TreatmentView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct TreatmentView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Text(EducationText.treatedEoE)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                Text(EducationText.howEoETreated2)
                    .educationBodyStyle()
                
                Text(EducationText.howEoETreated)
                    .educationBodyStyle()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(EducationText.optionA)
                    Text(EducationText.optionB)
                    Text(EducationText.optionC)
                }
                .font(.body)
                .foregroundColor(Color("PrimaryColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                
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
