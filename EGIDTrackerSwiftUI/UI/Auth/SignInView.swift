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
            VStack(spacing: 20) {

                Text("EGID Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)

                Button {
                    viewModel.signIn()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Sign In")
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
                }

                NavigationLink("Don't have an account? Sign Up") {
                    SignUpView()
                }

                NavigationLink(
                    destination: HomeView(),
                    isActive: $goToHome
                ) {
                    EmptyView()
                }

                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.signInSucceeded) { succeeded in
                if succeeded {
                    goToHome = true
                }
            }
        }
    }
}
