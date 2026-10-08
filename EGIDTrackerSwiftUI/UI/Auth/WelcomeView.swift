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
            ZStack {
                Color.egidDarkPurple
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    Spacer()

                    // EGID Tracker logo
                    Image("EGID Logo 1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("EGID Tracker")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 15)

                    Text("Your companion for managing\nEGID and tracking your health.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)

                    Spacer()

                    // Get Started
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Get Started")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.egidCoral)
                            .clipShape(RoundedRectangle(cornerRadius: 26))
                    }
                    .buttonStyle(.plain)

                    // Create Account
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Create Account")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 12)

                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, 30)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
