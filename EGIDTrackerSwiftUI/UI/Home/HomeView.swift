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
                        
                        // Top Row (Journal + Logout)
                        HStack {
                            NavigationLink {
                                JournalView()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "book")
                                        .font(.title3)
                                    Text("Journal")
                                        .font(.subheadline).bold()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(25)
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                            
                            Button("Log Out", role: .destructive) {
                                viewModel.logOut()
                            }
                        }
                        
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
                        }
                    }
                    
                    LazyVGrid(columns: columns, spacing: 9) {
                        NavigationLink(destination: Text("Food Tracker")) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        NavigationLink(destination: FoodTrackerView()) {
                            GridButton(title: "Food Tracker", icon: "fork.knife")
                        }
                        NavigationLink(destination: SymptomCheckerView()) {
                            GridButton(title: "Symptom Score", icon: "thermometer")
                        }
                        NavigationLink(destination: PlanView()) {
                            GridButton(title: "Your Plan", icon: "doc.text.fill")
                        }
                        NavigationLink(destination: Text("Quality of Life Checker")) {
                            GridButton(title: "Quality of Life", icon: "heart.fill")
                        NavigationLink(destination: QoLView()) {               GridButton(title: "Quality of Life", icon: "heart.fill")
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: Text("EGID Education")) {
                            ListRow(title: "EGID Education", icon: "book.circle.fill")
                        }
                        NavigationLink(destination: ProfilesView()) {
                            ListRow(title: "Manage Profiles", icon: "person.2.circle.fill")
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal,20)
                    
                    Button("Log Out", role: .destructive) {
                        viewModel.logOut()
                    }
                    Spacer(minLength: 2)

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
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .frame(width: 42, height: 42, alignment: .leading)
                .padding(.top,17)
            Spacer(minLength: 5)
            Text(title)
                .font(.system(size: 18))
                .bold()
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom,15)
        }
        .padding(.horizontal,14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .background(Color("PrimaryColor").opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}

struct ListRow: View {
    let title: String
    let icon: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(Color("PrimaryColor").opacity(0.8))
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(Color("PrimaryColor"))
        }
        .padding(.horizontal,15)
        .padding(.vertical,10)
        .background(Color("PrimaryColor").opacity(0.05))
        .cornerRadius(15)
    }
}
#Preview {
    HomeView()
}
