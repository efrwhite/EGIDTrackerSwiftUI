//
//  HomeView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/4/26.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()
    @State private var goToSignIn = false

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {

                    // MARK: - Header

                    HStack {
                        Text("EGID TRACKER")
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        NavigationLink {
                            JournalView()
                        } label: {
                            Image(systemName: "book.closed")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 42, height: 44)
                                .accessibilityLabel("Journal")
                        }

                        Button {
                            viewModel.logOut()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 42, height: 44)
                        }
                        .accessibilityLabel("Log Out")
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.egidPurple)

                    VStack(spacing: 30) {

                        // MARK: - Patient Profile Card

                        HStack(spacing: 22) {

                            Group {
                                if viewModel.childImageUrl.isEmpty {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(25)
                                        .foregroundColor(.white)
                                } else {
                                    AsyncImage(
                                        url: URL(string: viewModel.childImageUrl)
                                    ) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(25)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(width: 100, height: 100)
                            .background(Color.egidCoral)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .overlay {
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.white, lineWidth: 2)
                            }
                            .accessibilityLabel(
                                viewModel.childName.isEmpty
                                    ? "Patient profile image"
                                    : "\(viewModel.childName)'s profile image"
                            )

                            VStack(alignment: .leading, spacing: 15) {

                                Text(
                                    viewModel.childName.isEmpty
                                        ? "Friend"
                                        : viewModel.childName
                                )
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .minimumScaleFactor(0.75)

                                Text(
                                    viewModel.childDiet.isEmpty
                                        ? "Diet not specified"
                                        : viewModel.childDiet.uppercased()
                                )
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.egidLightPurple)
                                .clipShape(Capsule())
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                            }

                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 190)
                        .background(Color.egidPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 44))
                        .overlay {
                            RoundedRectangle(cornerRadius: 44)
                                .stroke(
                                    Color.egidLightPurple.opacity(0.7),
                                    lineWidth: 1.5
                                )
                        }

                        // MARK: - Health Summary

                        HStack(spacing: 0) {

                            summaryItem(
                                value: "—",
                                title: "LOGGED\nSTREAK"
                            )

                            summaryItem(
                                value: "—",
                                title: "DAY\nSTREAK"
                            )

                            summaryItem(
                                value: "—",
                                title: "SYMPTOM\nSCORE"
                            )
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 100)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(
                                    Color.egidLightPurple.opacity(0.6),
                                    lineWidth: 1.5
                                )
                        }

                        // MARK: - Main Feature Buttons

                        VStack(spacing: 18) {

                            // First row: Your Plan and Food Tracker
                            LazyVGrid(columns: columns, spacing: 18) {

                                NavigationLink(destination: PlanView()) {
                                    featureCard(
                                        title: "Your Plan",
                                        icon: "list.clipboard",
                                        background: Color.egidDarkPurple
                                    )
                                }

                                NavigationLink(destination: FoodTrackerView()) {
                                    featureCard(
                                        title: "Food Tracker",
                                        icon: "fork.knife",
                                        background: Color.egidCoral
                                    )
                                }
                            }
                            .buttonStyle(.plain)

                            // Full-width row: Symptom Score Checker
                            NavigationLink(destination: SymptomCheckerView()) {
                                wideFeatureCard(
                                    title: "Symptom Score Checker",
                                    icon: "chart.bar.xaxis"
                                )
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)

                            // Last row: Quality of Life and EGID Education
                            LazyVGrid(columns: columns, spacing: 18) {

                                NavigationLink(destination: QoLView()) {
                                    featureCard(
                                        title: "Quality Of Life\nChecker",
                                        icon: "heart.text.square",
                                        background: Color.egidPurple
                                    )
                                }

                                NavigationLink(destination: EducationHomeView()) {
                                    featureCard(
                                        title: "EGID Education",
                                        icon: "graduationcap",
                                        background: Color.egidCoral
                                    )
                                }
                            }
                            .buttonStyle(.plain)
                        }

                        // MARK: - Manage Profiles

                        NavigationLink(destination: ProfilesView()) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.2.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.egidPurple)

                                Text("Manage Profiles")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color.egidDarkText)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.egidPurple)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        Color.egidLightPurple.opacity(0.6),
                                        lineWidth: 1
                                    )
                            }
                        }
                        .buttonStyle(.plain)

                        if viewModel.isLoading {
                            ProgressView("Loading profile...")
                                .frame(maxWidth: .infinity)
                        }

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.body)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }

                        NavigationLink(
                            destination: SignInView(),
                            isActive: $goToSignIn
                        ) {
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 24)
                    .padding(.bottom, 30)
                }
            }
            .background(Color.egidBackground.ignoresSafeArea())
            .task {
                await viewModel.loadHomeData()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .onChange(of: viewModel.didLogOut) { _, didLogOut in
                if didLogOut {
                    goToSignIn = true
                }
            }
        }
    }

    // MARK: - Health Summary Item

    private func summaryItem(
        value: String,
        title: String
    ) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.egidMediumPurple)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.egidMediumPurple)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 2)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Standard Feature Card

    private func featureCard(
        title: String,
        icon: String,
        background: Color
    ) -> some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 34, weight: .regular))
                .frame(height: 44)
                .accessibilityHidden(true)

            Text(title)
                .font(.system(size: 17, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 154)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .overlay {
            RoundedRectangle(cornerRadius: 36)
                .stroke(Color.white, lineWidth: 2)
        }
        .contentShape(RoundedRectangle(cornerRadius: 36))
    }

    // MARK: - Wide Symptom Score Card

    private func wideFeatureCard(
        title: String,
        icon: String
    ) -> some View {
        HStack(spacing: 22) {
            Image(systemName: icon)
                .font(.system(size: 42, weight: .medium))
                .foregroundColor(.cyan)
                .frame(width: 64, height: 64)
                .accessibilityHidden(true)

            Text(title)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 140)
        .background(Color.egidLightPurple)
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .overlay {
            RoundedRectangle(cornerRadius: 36)
                .stroke(Color.white, lineWidth: 2)
        }
        .contentShape(RoundedRectangle(cornerRadius: 36))
    }
}

// MARK: - Color Palette

extension Color {
    static let egidDarkPurple = Color(hex: "3D2557")
    static let egidPurple = Color(hex: "5B3A82")
    static let egidMediumPurple = Color(hex: "8B6FB3")
    static let egidLightPurple = Color(hex: "C9B6E4")
    static let egidBackground = Color(hex: "FBF8FF")
    static let egidCoral = Color(hex: "FF8F70")
    static let egidDarkCoral = Color(hex: "D96545")
    static let egidDarkText = Color(hex: "2D2438")
    static let egidMutedPurple = Color(hex: "8A82A0")

    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let red = Double((int >> 16) & 0xFF) / 255
        let green = Double((int >> 8) & 0xFF) / 255
        let blue = Double(int & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    HomeView()
}
