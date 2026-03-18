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

    // Published so SwiftUI can react to login state
    @Published private(set) var user: User?
    @Published private(set) var currentUsername: String?

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    private let appPrefsKey = "AppPreferences_CurrentUsername"

    init() {
        self.user = auth.currentUser
        self.currentUsername = UserDefaults.standard.string(forKey: appPrefsKey)
    }

    // MARK: - Sign In (Username + Password)
    func signIn(username: String, password: String) async throws {
        let usernameTrim = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordTrim = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !usernameTrim.isEmpty, !passwordTrim.isEmpty else {
            throw AuthServiceError.missingUsernameOrPassword
        }

        // 1) Look up email by username (Users where username == input)
        let snapshot = try await db.collection("Users")
            .whereField("username", isEqualTo: usernameTrim)
            .limit(to: 1)
            .getDocuments()

        guard let doc = snapshot.documents.first else {
            throw AuthServiceError.invalidUsernameOrPassword
        }

        let email = doc.get("email") as? String
        guard let email, !email.isEmpty else {
            throw AuthServiceError.failedToRetrieveEmail
        }

        // 2) Sign in with email + password
        let result = try await auth.signIn(withEmail: email, password: passwordTrim)

        // 3) Save username locally (UserDefaults)
        saveUsername(usernameTrim)

        // 4) Update published state
        self.user = result.user
        self.currentUsername = usernameTrim
    }

    // MARK: - Sign Up
    func signUp(username: String, phone: String, email: String, password: String, confirmPassword: String) async throws {
        let usernameTrim = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneTrim = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailTrim = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordTrim = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmTrim = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !usernameTrim.isEmpty,
              !phoneTrim.isEmpty,
              !emailTrim.isEmpty,
              !passwordTrim.isEmpty,
              !confirmTrim.isEmpty else {
            throw AuthServiceError.missingFields
        }

        guard passwordTrim == confirmTrim else {
            throw AuthServiceError.passwordsDoNotMatch
        }

        guard isPasswordValid(passwordTrim) else {
            throw AuthServiceError.passwordInvalid
        }

        // 1) Check username uniqueness against Users
        let isUnique = try await checkUsernameUnique(usernameTrim)
        guard isUnique else {
            throw AuthServiceError.usernameTaken
        }

        // 2) Create Auth user
        let result = try await auth.createUser(withEmail: emailTrim, password: passwordTrim)
        let uid = result.user.uid

        // 3) Save profile in Users/{uid}
        let userMap: [String: Any] = [
            "email": emailTrim,
            "username": usernameTrim,
            "phone": phoneTrim
        ]

        try await db.collection("Users").document(uid).setData(userMap)

        // 4) Save username locally
        saveUsername(usernameTrim)

        // 5) Update published state
        self.user = result.user
        self.currentUsername = usernameTrim
    }

    // MARK: - Logout
    func signOut() throws {
        // Android clears child pref on logout; we’ll handle child selection in another service.
        // For now: clear username and sign out.
        clearUsername()
        try auth.signOut()

        self.user = nil
        self.currentUsername = nil
    }

    // MARK: - Username Prefs (UserDefaults)
    private func saveUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: appPrefsKey)
    }

    private func clearUsername() {
        UserDefaults.standard.removeObject(forKey: appPrefsKey)
    }

    // Helpers
    private func checkUsernameUnique(_ username: String) async throws -> Bool {
        let snapshot = try await db.collection("Users")
            .whereField("username", isEqualTo: username)
            .limit(to: 1)
            .getDocuments()

        return snapshot.documents.isEmpty
    }

    private func isPasswordValid(_ password: String) -> Bool {
        // "^(?=.*[A-Z])(?=.*[!@#\\$])[A-Za-z\\d!@#\\$]{7,}$"
        let pattern = #"^(?=.*[A-Z])(?=.*[!@#\$])[A-Za-z\d!@#\$]{7,}$"#
        return password.range(of: pattern, options: .regularExpression) != nil
    }
}

// Errors
enum AuthServiceError: LocalizedError {
    case missingUsernameOrPassword
    case invalidUsernameOrPassword
    case failedToRetrieveEmail
    case missingFields
    case passwordsDoNotMatch
    case passwordInvalid
    case usernameTaken

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
        }
    }
}
