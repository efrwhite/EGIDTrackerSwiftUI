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
        VStack(spacing: 16) {
            
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
            
            TextField("Phone", text: $viewModel.phone)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.phonePad)
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .textFieldStyle(.roundedBorder)
            
            Button {
                viewModel.signUp()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Sign Up")
                        .bold()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            if let success = viewModel.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
            }
            
            Button("Back to Sign In") {
                dismiss()
            }
            .padding(.top, 8)
            
            NavigationLink(
                destination: CaregiverProfileView(isFirstTimeUser: true),
                isActive: $goToCaregiverProfile
            ) {
                EmptyView()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.signUpSucceeded) { succeeded in
            if succeeded {
                goToCaregiverProfile = true
            }
        }
    }
}
