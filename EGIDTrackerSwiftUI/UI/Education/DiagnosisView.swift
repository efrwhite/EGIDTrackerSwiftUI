//
//  DiagnosisView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct DiagnosisView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                
                Text(EducationText.diagnosedEoE)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                Text(EducationText.howEoEDiagnosed2)
                    .educationBodyStyle()
                
                Text(EducationText.howEoEDiagnosed)
                    .educationBodyStyle()
                
                HStack(alignment: .top, spacing: 16) {
                    VStack(spacing: 8) {
                        Image("normalesophagus")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 130)
                        
                        Text(EducationText.normalEsophagus)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 8) {
                        Image("eoesophagus")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 130)
                        
                        Text(EducationText.eoeEsophagus)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 10)
                
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
