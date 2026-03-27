//
//  SignUpView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var goToCaregiverProfile = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Image("signup_bgvector")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea()
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello,")
                            .font(.subheadline)
                        Text("Sign Up!")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 35)
                    .foregroundColor(.white)
                }
                .background(Color.clear)
                VStack(spacing: 20) {
                    
                    VectorIconField(icon: "person.fill", placeholder: "Username", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .padding(.top, 20)
                    
                    VectorIconField(icon: "phone.fill", placeholder: "Phone", text: $viewModel.phone, keyboard: .phonePad)
                    
                    VectorIconField(icon: "envelope.fill", placeholder: "Email", text: $viewModel.email, keyboard: .emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    VectorIconField(icon: "lock.fill", placeholder: "Password", text: $viewModel.password, isSecure: true)
                    
                    VectorIconField(icon: "lock.shield.fill", placeholder: "Confirm Password", text: $viewModel.confirmPassword, isSecure: true)
                    
                    // Sign Up Button
                    Button {
                        viewModel.signUp()
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        } else {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal,11)
                    .padding(.top, 10)
                    .disabled(viewModel.isLoading)
                    .tint(Color("PrimaryColor"))
                    
                    // Messages
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    
                    if let success = viewModel.successMessage {
                        Text(success)
                            .foregroundColor(.green)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Back to Sign In") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)

                    NavigationLink(
                        destination: CaregiverProfileView(isFirstTimeUser: true),
                        isActive: $goToCaregiverProfile
                    ) {
                        EmptyView()
                    }
                }
                .padding(24)
            }
            
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .onChange(of: viewModel.signUpSucceeded) { succeeded in
            if succeeded {
                goToCaregiverProfile = true
            }
        }
    }
}
