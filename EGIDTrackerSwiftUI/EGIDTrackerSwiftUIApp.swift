//
//  EGIDTrackerSwiftUIApp.swift
//  EGIDTrackerSwiftUI
//
//  Created by Elizabeth Baker on 2/28/26.
//


import SwiftUI
import FirebaseCore

@main
struct EGIDTrackerSwiftUIApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}

