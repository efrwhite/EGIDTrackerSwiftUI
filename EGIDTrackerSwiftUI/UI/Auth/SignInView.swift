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
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.egidDarkPurple
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // LOGO
                        Image("EGID Logo 1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 105, height: 95)
                            .padding(.top, 18)
                        
                        // LOGIN TITLE
                        Text("Login")
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 2)
                            .padding(.bottom, 18)
                        
                        // EMAIL
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color.egidPurple)
                                
                                TextField(
                                    "Enter your email",
                                    text: $viewModel.username
                                )
                                .font(.system(size: 14))
                                .foregroundColor(Color.egidDarkText)
                                .tint(Color.egidPurple)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        // PASSWORD
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Password")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color.egidPurple)
                                
                                if isPasswordVisible {
                                    TextField(
                                        "Enter your password",
                                        text: $viewModel.password
                                    )
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.egidDarkText)
                                    .tint(Color.egidPurple)
                                } else {
                                    SecureField(
                                        "Enter your password",
                                        text: $viewModel.password
                                    )
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.egidDarkText)
                                    .tint(Color.egidPurple)
                                }
                                
                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(Color.egidPurple)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.top, 13)
                        
                        // FORGOT PASSWORD
                        HStack {
                            Spacer()
                            
                            Text("Forgot Password?")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 8)
                        
                        // ERROR
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                        }
                        
                        // LOGIN BUTTON
                        Button {
                            viewModel.signIn()
                        } label: {
                            Image("login button")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isLoading)
                        .padding(.top, 17)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .padding(.top, 5)
                        }
                        
                        // DIVIDER
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(height: 1)
                            
                            Text("or")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                            
                            Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(height: 1)
                        }
                        .padding(.top, 14)
                        
                        // APPLE
                        Button {
                            // Apple login can be connected later
                        } label: {
                            HStack {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 14))
                                
                                Text("Continue with Apple")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 17)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 10)
                        
                        // GOOGLE
                        Button {
                            // Google login can be connected later
                        } label: {
                            HStack {
                                Text("G")
                                    .font(.system(size: 15, weight: .bold))
                                
                                Text("Continue with Google")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 17)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 7)
                        
                        // FACEBOOK
                        Button {
                            // Facebook login can be connected later
                        } label: {
                            HStack {
                                Text("f")
                                    .font(.system(size: 17, weight: .bold))
                                
                                Text("Continue with Facebook")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 17)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 7)
                        
                        // SIGN UP
                        NavigationLink {
                            SignUpView()
                        } label: {
                            HStack(spacing: 3) {
                                Text("Don't have an account?")
                                    .foregroundColor(.white)
                                
                                Text("Sign Up")
                                    .foregroundColor(Color.egidCoral)
                                    .bold()
                            }
                            .font(.system(size: 11))
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        
                        NavigationLink(
                            destination: HomeView(),
                            isActive: $goToHome
                        ) {
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 24)
                }
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

#Preview {
    SignInView()
}
