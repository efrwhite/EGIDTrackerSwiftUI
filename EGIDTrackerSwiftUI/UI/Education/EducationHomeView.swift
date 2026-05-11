//
//  EducationHomeView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct EducationHomeView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                NavigationLink(destination: WhatIsEoEView()) {
                    educationCard(icon: "magnifyingglass", title: "What is EGID and EoE?")
                }

                NavigationLink(destination: CausesView()) {
                    educationCard(icon: "doc.text", title: "What Causes EGID and EoE?")
                }

                NavigationLink(destination: AffectedView()) {
                    educationCard(icon: "person.2.fill", title: "Who is Affected?")
                }

                NavigationLink(destination: SymptomsView()) {
                    educationCard(icon: "stethoscope", title: "What are the Symptoms?")
                }

                NavigationLink(destination: DiagnosisView()) {
                    educationCard(icon: "list.clipboard", title: "How is it Diagnosed?")
                }

                NavigationLink(destination: TreatmentView()) {
                    educationCard(icon: "pills.fill", title: "How is it Treated?")
                }

                NavigationLink(destination: ResourcesView()) {
                    educationCard(icon: "lightbulb.fill", title: "Where Can I Find More Info?")
                }
            }
            .padding()
        }
        .background(Color("PrimaryBackground"))
        .navigationTitle("Education")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func educationCard(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(Color("PrimaryColor"))
                .frame(width: 34, height: 34)
                .background(Color.white.opacity(0.95))
                .clipShape(Circle())
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(Color("SecondaryColor"))
        .cornerRadius(24)
    }
}
