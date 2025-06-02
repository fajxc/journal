//
//  journalApp.swift
//  journal
//
//  Created by Fajar Kakakhel on 2025-05-29.
//

import SwiftUI
import UIKit

@main
struct JournalApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Theme.textSecondary)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Theme.textSecondary)]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(Theme.textSecondary)
        
        // Restore session on app launch
        SupabaseManager.shared.restoreSession()
        if let _ = SupabaseManager.shared.accessToken, let _ = SupabaseManager.shared.userId {
            isSignedIn = true
        } else {
            isSignedIn = false
            isGuestUser = false
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
