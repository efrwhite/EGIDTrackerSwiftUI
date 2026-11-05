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

            VStack(alignment: .leading, spacing: 30) {

                // Header
                Text("EGID TRACKER")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .background(Color.egidPurple)

                // Education topics
                VStack(spacing: 30) {

                    NavigationLink(destination: WhatIsEoEView()) {
                        educationRow(
                            title: "What is EGID and EoE?",
                            icon: "magnifyingglass"
                        )
                    }

                    NavigationLink(destination: CausesView()) {
                        educationRow(
                            title: "Whats Causes EGID and EoE?",
                            icon: "folder"
                        )
                    }

                    NavigationLink(destination: AffectedView()) {
                        educationRow(
                            title: "Who is Affected?",
                            icon: "person.2"
                        )
                    }

                    NavigationLink(destination: SymptomsView()) {
                        educationRow(
                            title: "What are the Symptoms?",
                            icon: "flask"
                        )
                    }

                    NavigationLink(destination: DiagnosisView()) {
                        educationRow(
                            title: "How is it Diagnosed?",
                            icon: "calendar"
                        )
                    }

                    NavigationLink(destination: TreatmentView()) {
                        educationRow(
                            title: "How is it Treated?",
                            icon: "point.3.connected.trianglepath.dotted"
                        )
                    }

                    NavigationLink(destination: ResourcesView()) {
                        educationRow(
                            title: "Where Can I Find More Info?",
                            icon: "lightbulb"
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 35)
        }
        .background(Color.white)

        // Display the standard iPhone navigation bar
        .toolbarBackground(Color.egidPurple, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // Individual education button
    private func educationRow(
        title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 18) {

            Image(systemName: icon)
                .font(.system(size: 32, weight: .regular))
                .foregroundColor(.white)
                .frame(width: 82, height: 82)
                .background(Color.egidCoral)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                }
                .accessibilityHidden(true)

            Text(title)
                .font(.system(size: 23, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 132)
        .background(Color.egidPurple)
        .clipShape(RoundedRectangle(cornerRadius: 38))
        .overlay {
            RoundedRectangle(cornerRadius: 38)
                .stroke(Color.egidLightPurple, lineWidth: 3)
        }
        .contentShape(RoundedRectangle(cornerRadius: 38))
    }
}

#Preview {
    NavigationStack {
        EducationHomeView()
    }
}


