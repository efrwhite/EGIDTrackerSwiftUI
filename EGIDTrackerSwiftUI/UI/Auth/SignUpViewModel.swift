//
//  SignUpViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var signUpSucceeded: Bool = false
    
    private let authService = FirebaseAuthService()
    
    func signUp() {
        print("Sign up button tapped")
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        signUpSucceeded = false
        
        Task {
            do {
                print("⏳ Attempting sign-up for username: \(username)")
                
                try await authService.signUp(
                    username: username,
                    phone: phone,
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword
                )
                
                print("Sign-up succeeded")
                successMessage = "Account created successfully!"
                signUpSucceeded = true
                
            } catch {
                print("Sign-up failed: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}
