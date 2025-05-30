import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentStep = 0
    @State private var selectedIdeologies: Set<String> = []
    @State private var lifeCheckText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Progress indicator
            HStack(spacing: 8) {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: Theme.cornerRadius / 2)
                        .fill(currentStep >= index ? Theme.accentColor : Theme.cardBackground)
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, Theme.screenPadding)
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    switch currentStep {
                    case 0:
                        welcomeStep
                    case 1:
                        lifeCheckStep
                    case 2:
                        perspectiveStep
                    case 3:
                        PhilosophyWordCloud(selectedTraits: $selectedIdeologies)
                    default:
                        EmptyView()
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
            }
            
            Spacer()
            
            // Navigation button
            Button(action: {
                if currentStep < 3 {
                    currentStep += 1
                } else {
                    hasCompletedOnboarding = true
                }
            }) {
                Text(currentStep < 3 ? "continue" : "get started")
                    .font(Theme.bodyStyle)
                    .foregroundColor(Theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.buttonStyle(isProminent: true))
                    .cornerRadius(Theme.cornerRadius)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, Theme.screenPadding)
        }
        .background(Theme.backgroundColor)
        .preferredColorScheme(.dark)
    }
    
    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("welcome.")
                .font(Theme.headerStyle)
                .foregroundColor(Theme.textPrimary)
            
            Text("a space for reflection, growth, and philosophical insight")
                .font(Theme.bodyStyle)
                .foregroundColor(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var lifeCheckStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("how are you feeling about your life right now?")
                .font(Theme.headerStyle)
                .foregroundColor(Theme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            TextEditor(text: $lifeCheckText)
                .font(Theme.bodyStyle)
                .foregroundColor(Theme.textPrimary)
                .scrollContentBackground(.hidden)
                .frame(height: 120)
                .padding()
                .background(Theme.cardBackground.opacity(0.4))
                .cornerRadius(Theme.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .stroke(Theme.cardBackground, lineWidth: 1)
                )
        }
    }
    
    private var perspectiveStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("do you feel like you lack a different perspective in life?")
                .font(Theme.headerStyle)
                .foregroundColor(Theme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 12) {
                ForEach(["yes", "sometimes", "no"], id: \.self) { option in
                    Button(action: { currentStep += 1 }) {
                        Text(option)
                            .font(Theme.bodyStyle)
                            .foregroundColor(Theme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
} 