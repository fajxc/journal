import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else if !isSignedIn && !isGuestUser {
                SignInView()
            } else {
                MainTabView()
            }
        }
        .background(Theme.backgroundColor)
        .preferredColorScheme(.dark)
        .tint(Theme.accentColor)
    }
}

#Preview {
    RootView()
} 