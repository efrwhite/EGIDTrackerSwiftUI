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

    private let backgroundColor = Color(
        red: 91 / 255,
        green: 58 / 255,
        blue: 130 / 255
    )

    private let coralColor = Color(
        red: 1.0,
        green: 143 / 255,
        blue: 112 / 255
    )

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {

                    // Register heading
                    Text("Register")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 45)
                        .padding(.bottom, 45)

                    VStack(spacing: 20) {

                        // First Name and Last Name
                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                fieldLabel("First Name")

                                TextField("John", text: $viewModel.firstName)
                                    .textContentType(.givenName)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled()
                                    .registerFieldStyle()
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                fieldLabel("Last Name")

                                TextField("Doe", text: $viewModel.lastName)
                                    .textContentType(.familyName)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled()
                                    .registerFieldStyle()
                            }
                        }

                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            fieldLabel("E-mail")

                            TextField("Enter your email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .registerFieldStyle()
                        }

                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            fieldLabel("Password")

                            SecureField("Enter your password", text: $viewModel.password)
                                .textContentType(.newPassword)
                                .registerFieldStyle()
                        }

                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            fieldLabel("Confirm Password")

                            SecureField(
                                "Confirm your password",
                                text: $viewModel.confirmPassword
                            )
                            .textContentType(.newPassword)
                            .registerFieldStyle()
                        }

                        // Mobile Number
                        VStack(alignment: .leading, spacing: 8) {
                            fieldLabel("Mobile Number")

                            TextField("Enter your mobile number", text: $viewModel.phone)
                                .keyboardType(.phonePad)
                                .textContentType(.telephoneNumber)
                                .registerFieldStyle()
                        }

                        // Username
                        VStack(alignment: .leading, spacing: 8) {
                            fieldLabel("Username")

                            TextField("Choose a username", text: $viewModel.username)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .registerFieldStyle()
                        }
                    }

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 12)
                    }

                    // Success message
                    if let success = viewModel.successMessage {
                        Text(success)
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 12)
                    }

                    // Create Account button
                    Button {
                        viewModel.signUp()
                    } label: {
                        Group {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Create Account")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(coralColor)
                        .clipShape(Capsule())
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.top, 45)

                    // Terms and privacy text
                    VStack(spacing: 5) {
                        Text("By continuing, you agree to our")
                            .foregroundColor(.white)
                        +
                        Text(" Terms of Service")
                            .foregroundColor(Color(red: 0.82, green: 0.72, blue: 0.91))
                            .underline()
                    }
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)

                    HStack(spacing: 4) {
                        Text("and")
                            .foregroundColor(.white)

                        Text("Privacy Policy")
                            .foregroundColor(Color(red: 0.82, green: 0.72, blue: 0.91))
                            .underline()

                        Text(".")
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 14))
                    .padding(.top, 2)

                    // Back to Sign In
                    Button("Back to Sign In") {
                        dismiss()
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.top, 28)

                    // Preserve existing navigation
                    NavigationLink(
                        destination: CaregiverProfileView(isFirstTimeUser: true),
                        isActive: $goToCaregiverProfile
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 35)
                .frame(minHeight: geometry.size.height, alignment: .top)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .background(backgroundColor.ignoresSafeArea())
            .scrollDismissesKeyboard(.interactively)
        }
        .background(backgroundColor.ignoresSafeArea())
        .preferredColorScheme(.light)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.signUpSucceeded) { succeeded in
            if succeeded {
                goToCaregiverProfile = true
            }
        }
    }

    // MARK: - Field Label
    private func fieldLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
    }
}

// MARK: - Registration Field Style
private extension View {
    func registerFieldStyle() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(Color(red: 0.18, green: 0.14, blue: 0.22))
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .overlay {
                RoundedRectangle(cornerRadius: 13)
                    .stroke(Color(red: 0.86, green: 0.85, blue: 0.90), lineWidth: 1.5)
            }
    }
}

