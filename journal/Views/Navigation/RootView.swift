import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    
    private enum Phase { case onboarding, signin, home }
    @State private var phase: Phase = .onboarding
    @State private var animatingPhase: Phase? = nil
    @State private var showNewPhase = false
    
    private func determinePhase() -> Phase {
        if !hasCompletedOnboarding {
            return .onboarding
        } else if !isSignedIn && !isGuestUser {
            return .signin
        } else {
            return .home
        }
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.ignoresSafeArea()
            // Old phase view
            Group {
                switch animatingPhase ?? phase {
                case .onboarding:
                    OnboardingView()
                case .signin:
                    SignInView()
                case .home:
                    MainTabView()
                }
            }
            .opacity(showNewPhase ? 0 : 1)
            // New phase view (fades in)
            if showNewPhase {
                Group {
                    switch phase {
                    case .onboarding:
                        OnboardingView()
                    case .signin:
                        SignInView()
                    case .home:
                        MainTabView()
                    }
                }
                .opacity(showNewPhase ? 1 : 0)
                .animation(.easeInOut(duration: 1.5), value: showNewPhase)
            }
        }
        .onAppear {
            phase = determinePhase()
        }
        .onChange(of: hasCompletedOnboarding) { _ in animatePhaseChange() }
        .onChange(of: isSignedIn) { _ in animatePhaseChange() }
        .onChange(of: isGuestUser) { _ in animatePhaseChange() }
        .background(Theme.backgroundColor)
        .preferredColorScheme(.dark)
        .tint(Theme.accentColor)
    }
    
    private func animatePhaseChange() {
        let newPhase = determinePhase()
        guard newPhase != phase else { return }
        animatingPhase = phase
        phase = newPhase
        showNewPhase = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            animatingPhase = nil
            showNewPhase = false
        }
    }
}

#Preview {
    RootView()
} 
