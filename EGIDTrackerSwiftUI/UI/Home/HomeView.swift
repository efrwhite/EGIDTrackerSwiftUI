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
    
    // Grid settings: 2 columns
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 10) {
                        Text("Home")
                            .font(.title2.bold())
                            .bold()
                        
                        Group {
                            if viewModel.childImageUrl.isEmpty {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundStyle(.gray)
                            } else {
                                AsyncImage(url: URL(string: viewModel.childImageUrl)) { image in
                                    image.resizable().scaledToFill()
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
                        
                        Text(viewModel.childName.isEmpty ? "Friend" : viewModel.childName)
                            .font(.title2)
                            .bold()
                        
                        Text("Diet: \(viewModel.childDiet)")
                            .foregroundStyle(.secondary)
                        
                        if viewModel.isLoading { ProgressView() }
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    LazyVGrid(columns: columns, spacing: 12) {
                        NavigationLink(destination: Text("Food Tracker")) {
                            GridButton(title: "Food Tracker", icon: "fork.knife")
                        }
                        NavigationLink(destination: Text("Symptom Score")) {
                            GridButton(title: "Symptom Score", icon: "thermometer")
                        }
                        NavigationLink(destination: PlanView()) {
                            GridButton(title: "Your Plan", icon: "doc.text.fill")
                        }
                        NavigationLink(destination: Text("Quality of Life Checker")) {               GridButton(title: "Quality of Life", icon: "heart.fill")
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 28)
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: Text("EGID Education")) {
                            ListRow(title: "EGID Education", icon: "book.fill")
                        }
                        NavigationLink(destination: ProfilesView()) {
                            ListRow(title: "Manage Profiles", icon: "person.2.fill")
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 2)

                    Button("Log Out", role: .destructive) {
                        viewModel.logOut()
                    }
                    NavigationLink(destination: SignInView(), isActive: $goToSignIn) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .task {
                await viewModel.loadHomeData()
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.didLogOut) { _, didLogOut in
                if didLogOut { goToSignIn = true }
            }
        }
    }
}

struct GridButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon).font(.title)
            Text(title).font(.footnote).bold()
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color("SecondaryColor").opacity(0.09))
        .foregroundColor(Color("SecondaryColor"))
        .cornerRadius(12)
    }
}

struct ListRow: View {
    let title: String
    let icon: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(Color("SecondaryColor"))
            Text(title).foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(Color("SecondaryColor"))
        }
        .padding()
        .background(Color("SecondaryColor").opacity(0.09))
        .cornerRadius(10)
    }
}
