//
//  WhatIsEoEView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct WhatIsEoEView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                
                Text(EducationText.whatEoE)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                Text(EducationText.eoeDefinition2)
                    .educationBodyStyle()
                
                Image("egidwhatisgraphic")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                
                Text(EducationText.eoeDefinition3)
                    .educationBodyStyle()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("• \(EducationText.eoeDefinition4)")
                    Text("• \(EducationText.eoeDefinition5)")
                    Text("• \(EducationText.eoeDefinition6)")
                }
                .font(.body)
                .foregroundColor(Color("PrimaryColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                
                Text(EducationText.eoeDefinition)
                    .educationBodyStyle()
                
                HStack(alignment: .top, spacing: 16) {
                    VStack(spacing: 8) {
                        Image("eosinophil")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 135)
                        
                        Text(EducationText.eosinophil)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    
                    VStack(spacing: 8) {
                        Image("eosinophilicesophagitis2")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 135)
                        
                        Text(EducationText.eoeEsophagus)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(20)
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
            .padding(.horizontal, 12)
    }
}
