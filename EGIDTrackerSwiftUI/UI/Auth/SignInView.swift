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
                Color.egidPurple
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Login title
                        Text("Login")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 120)
                            .padding(.bottom, 42)

                        // Username label
                        HStack(spacing: 3) {
                            Text("Username")
                                .foregroundColor(.white)

                            Text("*")
                                .foregroundColor(.red)

                            Spacer()
                        }
                        .font(.system(size: 12, weight: .medium))
                        .padding(.bottom, 7)

                        // Username field
                        HStack(spacing: 10) {
                            Image(systemName: "circle")
                                .foregroundColor(Color.egidLightPurple)

                            TextField(
                                "Enter your Username",
                                text: $viewModel.username
                            )
                            .font(.system(size: 14))
                            .foregroundColor(Color.egidDarkText)
                            .tint(Color.egidPurple)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)

                            Image(systemName: "circle")
                                .foregroundColor(Color.egidLightPurple)
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 44)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        // Password field
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Password")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)

                            HStack(spacing: 10) {
                                if isPasswordVisible {
                                    TextField(
                                        "Enter your password",
                                        text: $viewModel.password
                                    )
                                    .textContentType(.password)
                                    .textInputAutocapitalization(.never)
                                } else {
                                    SecureField(
                                        "Enter your password",
                                        text: $viewModel.password
                                    )
                                    .textContentType(.password)
                                    .textInputAutocapitalization(.never)
                                }

                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(
                                        systemName: isPasswordVisible
                                            ? "eye"
                                            : "eye.slash"
                                    )
                                    .foregroundColor(
                                        Color.egidDarkText.opacity(0.65)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            .font(.system(size: 14))
                            .foregroundColor(Color.egidDarkText)
                            .tint(Color.egidPurple)
                            .padding(.horizontal, 14)
                            .frame(height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.top, 36)

                        // Forgot password label
                        HStack {
                            Spacer()

                            Text("Forgot Password?")
                                .font(.system(size: 12, weight: .medium))
                                .underline()
                                .foregroundColor(.white)
                        }
                        .padding(.top, 12)

                        // Authentication error
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                        }

                        // Login button
                        Button {
                            viewModel.signIn()
                        } label: {
                            Image("login button")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .clipped()
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isLoading)
                        .padding(.top, 20)

                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .padding(.top, 8)
                        }

                        // Divider
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(Color.egidDarkText.opacity(0.6))
                                .frame(height: 1)

                            Text("Or")
                                .font(.system(size: 12))
                                .foregroundColor(Color.egidDarkText)

                            Rectangle()
                                .fill(Color.egidDarkText.opacity(0.6))
                                .frame(height: 1)
                        }
                        .padding(.top, 62)

                        // Centered social sign-in buttons
                        socialButton(
                            title: "Continue with Apple",
                            icon: .apple
                        )

                        socialButton(
                            title: "Continue with Google",
                            icon: .google
                        )

                        socialButton(
                            title: "Continue with Facebook",
                            icon: .facebook
                        )

                        // Sign up
                        NavigationLink {
                            SignUpView()
                        } label: {
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(.white)

                                Text("Sign Up")
                                    .foregroundColor(Color.egidCoral)
                                    .fontWeight(.bold)
                            }
                            .font(.system(size: 11))
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 18)
                        .padding(.bottom, 24)

                        // Navigate after successful sign-in
                        NavigationLink(
                            destination: HomeView(),
                            isActive: $goToHome
                        ) {
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity)
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

    // Social button icons
    private enum SocialIcon {
        case apple
        case google
        case facebook
    }

    // Center the icon and text as one group
    private func socialButton(
        title: String,
        icon: SocialIcon
    ) -> some View {
        Button {
            // Social authentication is not connected yet.
        } label: {
            HStack(spacing: 10) {
                Group {
                    switch icon {
                    case .apple:
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)

                    case .google:
                        Image("GoogleLogo")
                            .resizable()
                            .renderingMode(.original)
                            .scaledToFit()

                    case .facebook:
                        Image("FacebookLogo")
                            .resizable()
                            .renderingMode(.original)
                            .scaledToFit()
                    }
                }
                .frame(width: 20, height: 20)
                .clipped()

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 42)
            .contentShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(
                        Color.egidLightPurple.opacity(0.9),
                        lineWidth: 1.5
                    )
            }
        }
        .buttonStyle(.plain)
        .padding(.top, 12)
    }
}

#Preview {
    SignInView()
}


