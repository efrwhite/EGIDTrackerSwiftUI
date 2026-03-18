//
//  HomeView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/4/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var goToSignIn = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Home")
                    .font(.largeTitle)
                    .bold()
                
                Group {
                    if viewModel.childImageUrl.isEmpty {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.gray)
                    } else {
                        AsyncImage(url: URL(string: viewModel.childImageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    }
                }
                
                Text(viewModel.childName)
                    .font(.title2)
                    .bold()
                
                Text("Diet: \(viewModel.childDiet)")
                    .foregroundStyle(.secondary)
                
                if viewModel.isLoading {
                    ProgressView()
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                NavigationLink("Profiles") {
                    ProfilesView()
                }
                .buttonStyle(.bordered)
                
                NavigationLink("Your Plan") {
                    PlanView()
                }
                .buttonStyle(.bordered)
                
                Button("Food Tracker") {
                    print("Food Tracker tapped")
                }
                .buttonStyle(.bordered)
                
                Button("Symptom Score Checker") {
                    print("Symptom Score Checker tapped")
                }
                .buttonStyle(.bordered)
                
                Button("Quality of Life Checker") {
                    print("Quality of Life Checker tapped")
                }
                .buttonStyle(.bordered)
                
                Button("EGID Education") {
                    print("EGID Education tapped")
                }
                .buttonStyle(.bordered)
                
                Button("Log Out", role: .destructive) {
                    viewModel.logOut()
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink(destination: SignInView(), isActive: $goToSignIn) {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding()
            .task {
                await viewModel.loadHomeData()
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.didLogOut) { didLogOut in
                if didLogOut {
                    goToSignIn = true
                }
            }
        }
    }
}
