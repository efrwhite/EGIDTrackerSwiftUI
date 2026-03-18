//
//  SignInViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/4/26.
//

import Combine
import Foundation

@MainActor
final class SignInViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var signInSucceeded: Bool = false

    private let authService = FirebaseAuthService()

    func signIn() {
        print("SignIn button tapped")

        isLoading = true
        errorMessage = nil
        successMessage = nil
        signInSucceeded = false

        Task {
            do {
                print("⏳ Attempting sign-in for username: \(username)")
                try await authService.signIn(
                    username: username,
                    password: password
                )

                print("Sign-in succeeded")
                successMessage = "Signed in successfully!"
                signInSucceeded = true
            } catch {
                print("Sign-in failed: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
