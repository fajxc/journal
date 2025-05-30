//
//  journalApp.swift
//  journal
//
//  Created by Fajar Kakakhel on 2025-05-29.
//

import SwiftUI

@main
struct JournalApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
