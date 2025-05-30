import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentStep = 0
    @State private var selectedIdeologies: Set<String> = []
    @State private var lifeCheckText = ""
    @State private var selectedPerspective: String? = nil
    
    private var canContinue: Bool {
        switch currentStep {
        case 0: // Welcome step
            return true
        case 1: // Life check step
            return !lifeCheckText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2: // Perspective step
            return selectedPerspective != nil
        case 3: // Philosophy word cloud
            return selectedIdeologies.count >= 3 && selectedIdeologies.count <= 5
        default:
            return false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Progress and back button
            HStack {
                if currentStep > 0 {
                    Button(action: { currentStep -= 1 }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Theme.textPrimary)
                            .imageScale(.large)
                    }
                    .padding(.leading, Theme.screenPadding)
                }
                
                Spacer()
                
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        RoundedRectangle(cornerRadius: Theme.cornerRadius / 2)
                            .fill(currentStep >= index ? Theme.accentColor : Theme.cardBackground)
                            .frame(height: 4)
                    }
                }
                .frame(width: 120)
                
                Spacer()
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
                            .overlay(
                                VStack {
                                    Spacer()
                                    if !canContinue {
                                        Text("Select 3-5 words")
                                            .font(Theme.captionStyle)
                                            .foregroundColor(Theme.textSecondary)
                                            .padding(.vertical, 8)
                                    }
                                }
                            )
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
                Text(currentStep < 3 ? "Continue" : "Get Started")
                    .font(Theme.bodyStyle)
                    .foregroundColor(Theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canContinue ? Theme.accentColor : Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadius)
            }
            .disabled(!canContinue)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, Theme.screenPadding)
        }
        .background(Theme.backgroundColor)
        .preferredColorScheme(.dark)
    }
    
    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("welcome")
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
                    Button(action: { selectedPerspective = option }) {
                        Text(option)
                            .font(Theme.bodyStyle)
                            .foregroundColor(Theme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedPerspective == option ? Theme.accentColor : Theme.cardBackground)
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
