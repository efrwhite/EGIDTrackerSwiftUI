//
//  ResourcesView.swift
//  EGID Tracker
//
//  Created by lauren viado on 5/11/26.
//

import SwiftUI

struct ResourcesView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                
                Text(EducationText.moreInfo)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                resourceButton(
                    title: EducationText.naspghanButton,
                    subtitle: EducationText.naspghanText,
                    url: "https://www.naspghan.org/"
                )
                
                resourceButton(
                    title: EducationText.aaaiButton,
                    subtitle: EducationText.aaaiText,
                    url: "https://www.aaaai.org/"
                )
                
                resourceButton(
                    title: EducationText.apfedButton,
                    subtitle: EducationText.apfedText,
                    url: "https://apfed.org/"
                )
                
                resourceButton(
                    title: EducationText.chorButton,
                    subtitle: EducationText.chorText,
                    url: "https://www.chrichmond.org/"
                )
                
                resourceButton(
                    title: EducationText.cegirButton,
                    subtitle: EducationText.cegirText,
                    url: "https://cegir.rarediseasesnetwork.org/"
                )
                
                NavigationLink {
                    CustomResourcesView()
                } label: {
                    VStack(spacing: 6) {
                        Text("Custom Resources")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("PrimaryColor"))
                            .cornerRadius(12)
                        
                        Text("Add your own custom resources here")
                            .font(.body)
                            .foregroundColor(Color("PrimaryColor"))
                            .multilineTextAlignment(.center)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color("PrimaryBackground"))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func resourceButton(title: String, subtitle: String, url: String) -> some View {
        VStack(spacing: 6) {
            Button {
                openURL(url)
            } label: {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryColor"))
                    .cornerRadius(12)
            }
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(Color("PrimaryColor"))
                .multilineTextAlignment(.center)
        }
    }
    
    private func openURL(_ value: String) {
        guard let url = URL(string: value) else { return }
        UIApplication.shared.open(url)
    }
}
