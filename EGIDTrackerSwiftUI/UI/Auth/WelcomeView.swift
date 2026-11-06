//
//  Untitled.swift
//  EGID Tracker
//
//  Created by Diego Carcamo on 10/3/26.
//


import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.egidDarkPurple
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        Spacer(minLength: 20)

                        // EGID Tracker logo
                        Image("EGID Logo 1")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: min(geometry.size.width * 0.52, 220),
                                height: min(geometry.size.width * 0.52, 220)
                            )
                            .accessibilityLabel("EGID Tracker logo")

                        // App title
                        Text("EGID TRACKER")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundColor(Color.egidCoral)
                            .padding(.top, 14)

                        Spacer(minLength: 40)

                        // Welcome information panel
                        VStack(spacing: 16) {
                            Text("Let’s Get Started!")
                                .font(.system(size: 28, weight: .regular))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            // Keep each description sentence on one line
                            VStack(spacing: 4) {
                                Text("Track your symptoms, Medication and diet plans")
                                Text("Monitor your progress and response to therapy")
                                Text("Share results directly with your provider.")
                            }
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 30)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.egidLightPurple.opacity(0.48)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 40)
                        )

                        Spacer(minLength: 40)

                        // Register and Login buttons
                        HStack(spacing: 14) {
                            NavigationLink {
                                SignUpView()
                            } label: {
                                Text("Register")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.egidCoral)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .overlay {
                                        Capsule()
                                            .stroke(
                                                Color.egidCoral,
                                                lineWidth: 2
                                            )
                                    }
                            }
                            .buttonStyle(.plain)

                            NavigationLink {
                                SignInView()
                            } label: {
                                Text("Login")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.egidCoral)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 34)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
