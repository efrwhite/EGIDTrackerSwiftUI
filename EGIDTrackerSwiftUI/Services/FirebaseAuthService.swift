//
//  FirebaseAuthService.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/4/26.
//
//  Use this service for signup/login/logout



import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class FirebaseAuthService: ObservableObject {

    @Published private(set) var user: User?
    @Published private(set) var currentUsername: String?

    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let appPrefsKey = "AppPreferences_CurrentUsername"

    init() {
        self.user = auth.currentUser
        self.currentUsername = UserDefaults.standard.string(
            forKey: appPrefsKey
        )
    }

    // MARK: - Sign In
    func signIn(username: String, password: String) async throws {
        let usernameTrim = username.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let passwordTrim = password.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !usernameTrim.isEmpty, !passwordTrim.isEmpty else {
            throw AuthServiceError.missingUsernameOrPassword
        }

        // Look up the username using the public, exact-document lookup.
        let snapshot = try await db.collection("Usernames")
            .document(usernameTrim)
            .getDocument()

        guard let data = snapshot.data(),
              let email = data["email"] as? String,
              !email.isEmpty else {
            throw AuthServiceError.invalidUsernameOrPassword
        }

        let result = try await auth.signIn(
            withEmail: email,
            password: passwordTrim
        )

        saveUsername(usernameTrim)
        self.user = result.user
        self.currentUsername = usernameTrim
    }

    // MARK: - Sign Up
    func signUp(
        firstName: String,
        lastName: String,
        username: String,
        phone: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws {

        let firstNameTrim = firstName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let lastNameTrim = lastName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let usernameTrim = username.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let phoneTrim = phone.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let emailTrim = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let passwordTrim = password.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let confirmTrim = confirmPassword.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // 1. Validate required fields
        guard !firstNameTrim.isEmpty,
              !lastNameTrim.isEmpty,
              !usernameTrim.isEmpty,
              !phoneTrim.isEmpty,
              !emailTrim.isEmpty,
              !passwordTrim.isEmpty,
              !confirmTrim.isEmpty else {
            throw AuthServiceError.missingFields
        }

        // 2. Validate passwords
        guard passwordTrim == confirmTrim else {
            throw AuthServiceError.passwordsDoNotMatch
        }

        guard isPasswordValid(passwordTrim) else {
            throw AuthServiceError.passwordInvalid
        }

        // 3. Check username availability
        let isUnique = try await checkUsernameUnique(usernameTrim)

        guard isUnique else {
            throw AuthServiceError.usernameTaken
        }

        // 4. Create Firebase Authentication account
        let result = try await auth.createUser(
            withEmail: emailTrim,
            password: passwordTrim
        )
        let uid = result.user.uid

        // 5. Save the user's profile
        let userMap: [String: Any] = [
            "firstName": firstNameTrim,
            "lastName": lastNameTrim,
            "email": emailTrim,
            "username": usernameTrim,
            "phone": phoneTrim
        ]

        try await db.collection("Users")
            .document(uid)
            .setData(userMap)

        // 6. Create the username-to-email lookup document.
        // The Firestore rules permit creation only for the
        // authenticated user's own UID and verified email.
        guard let currentEmail = result.user.email,
              result.user.isEmailVerified else {
            throw AuthServiceError.emailVerificationRequired
        }

        let usernameMap: [String: Any] = [
            "uid": uid,
            "email": currentEmail
        ]

        try await db.collection("Usernames")
            .document(usernameTrim)
            .setData(usernameMap)

        // 7. Save username locally and update state
        saveUsername(usernameTrim)
        self.user = result.user
        self.currentUsername = usernameTrim
    }

    // MARK: - Logout
    func signOut() throws {
        try auth.signOut()
        clearUsername()

        self.user = nil
        self.currentUsername = nil
    }

    // MARK: - Username Preferences
    private func saveUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: appPrefsKey)
    }

    private func clearUsername() {
        UserDefaults.standard.removeObject(forKey: appPrefsKey)
    }

    // MARK: - Helpers
    private func checkUsernameUnique(_ username: String) async throws -> Bool {
        let snapshot = try await db.collection("Usernames")
            .document(username)
            .getDocument()

        return !snapshot.exists
    }

    private func isPasswordValid(_ password: String) -> Bool {
        // Requires at least 7 characters, an uppercase letter,
        // and a special character from the allowed set.
        let pattern = #"^(?=.*[A-Z])(?=.*[!@#$])[A-Za-z\d!@#$]{7,}$"#

        return password.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }
}

// MARK: - Errors
enum AuthServiceError: LocalizedError {
    case missingUsernameOrPassword
    case invalidUsernameOrPassword
    case failedToRetrieveEmail
    case missingFields
    case passwordsDoNotMatch
    case passwordInvalid
    case usernameTaken
    case emailVerificationRequired

    var errorDescription: String? {
        switch self {
        case .missingUsernameOrPassword:
            return "Username and password are required."
        case .invalidUsernameOrPassword:
            return "Invalid username or password."
        case .failedToRetrieveEmail:
            return "Failed to retrieve email for username."
        case .missingFields:
            return "Please fill in all fields."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        case .passwordInvalid:
            return "Password does not meet the requirements."
        case .usernameTaken:
            return "Username is already taken. Please choose another."
        case .emailVerificationRequired:
            return "Please verify your email before completing registration."
        }
    }
}


