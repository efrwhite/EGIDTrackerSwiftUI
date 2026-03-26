//
//  SignInView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/4/26.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject private var viewModel = SignInViewModel()
    @State private var goToHome = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Image("headerbackground")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 270)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome Back,")
                            .font(.subheadline)
                        Text("Log In!")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .padding(.bottom, 60)
                    }
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)
                }

                VStack(spacing: 25) {
                    VectorIconField(icon: "person.fill", placeholder: "Username", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .padding(.top, 40)
                    
                    VectorIconField(icon: "lock.fill", placeholder: "Password", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)

                        if let error = viewModel.errorMessage {
                            Text(error).foregroundColor(.red)
                        }
                        if let success = viewModel.successMessage {
                            Text(success).foregroundColor(.green)
                        }
                    

                    Button {
                        viewModel.signIn()
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        } else {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.top, 10)
                    .disabled(viewModel.isLoading)
                    .tint(Color("PrimaryColor"))
                    
                    NavigationLink("Don't have an account? Sign Up") {
                        SignUpView()
                    }
                    .foregroundColor(.secondary)
                    
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $goToHome
                    ) {
                        EmptyView()
                    }
                    
                    Spacer()
                }
                .padding(24)
                .background(Color(.systemBackground))
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.signInSucceeded) { succeeded in
                if succeeded {
                    goToHome = true
                }
            }
        }
    }
}
