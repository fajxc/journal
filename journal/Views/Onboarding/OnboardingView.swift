import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentStep = 0
    @State private var selectedMindsets: Set<String> = []
    @State private var selectedAge: String? = nil
    @State private var journalingTimes: [String: Bool] = [
        "Morning": true,
        "During the Day": true,
        "Evening": true
    ]
    @State private var selectedIdeologies: Set<String> = []
    @State private var lifeCheckText = ""
    @State private var selectedPerspective: String? = nil
    
    private var canContinue: Bool {
        switch currentStep {
        case 0: // Welcome
            return true
        case 1: // Mindset
            return !selectedMindsets.isEmpty
        case 2: // Age
            return selectedAge != nil
        case 3: // Journaling time
            return journalingTimes.values.contains(true)
        case 4: // Traits
            return selectedIdeologies.count >= 3 && selectedIdeologies.count <= 5
        default:
            return false
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress and back button
            HStack {
                if currentStep > 0 {
                    Button(action: { currentStep -= 1 }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    .padding(.leading, 24)
                }
                Spacer()
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(currentStep == index ? Color.white : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            Spacer(minLength: 24)
            // Content
            Group {
                switch currentStep {
                case 0:
                    welcomeStep
                case 1:
                    mindsetStep
                case 2:
                    ageStep
                case 3:
                    journalingTimeStep
                case 4:
                    PhilosophyWordCloud(selectedTraits: $selectedIdeologies)
                        .padding(.top, 16)
                default:
                    EmptyView()
                }
            }
            .padding(.horizontal, 24)
            Spacer()
            // Continue button
            Button(action: {
                if currentStep < 4 {
                    currentStep += 1
                } else {
                    hasCompletedOnboarding = true
                }
            }) {
                Text(currentStep < 4 ? "Continue" : "Get Started")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canContinue ? Color.white : Color.gray.opacity(0.3))
                    .cornerRadius(16)
            }
            .disabled(!canContinue)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
    
    // Slide 1: Welcome
    private var welcomeStep: some View {
        VStack(spacing: 40) {
            Spacer()
            VStack(spacing: 16) {
                Text("meet stoic.")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("your mental health companion")
                    .font(.system(size: 22))
                    .foregroundColor(Color.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            // Placeholder mascot
            Spacer()
            Image(systemName: "bird.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .foregroundColor(.white)
                .padding(.bottom, 40)
        }
    }
    
    // Slide 2: What's on your mind?
    private var mindsetStep: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 16)
            Text("What's on your mind?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text("Your answers will help shape the app around your needs.")
                .font(.system(size: 18))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
            VStack(spacing: 16) {
                ForEach(["Elevate mood", "Reduce stress & anxiety", "Improve sleep", "Increase productivity", "Something else"], id: \ .self) { option in
                    Button(action: {
                        if selectedMindsets.contains(option) {
                            selectedMindsets.remove(option)
                        } else {
                            selectedMindsets.insert(option)
                        }
                    }) {
                        HStack {
                            Text(option)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            if selectedMindsets.contains(option) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(selectedMindsets.contains(option) ? 0.4 : 0.2))
                        .cornerRadius(16)
                    }
                }
            }
            Spacer()
        }
    }
    
    // Slide 3: Age selection
    private var ageStep: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 16)
            Text("How old are you?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text("Your answers will help shape the app around your needs.")
                .font(.system(size: 18))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
            VStack(spacing: 16) {
                ForEach(["Under 18", "18–24", "25–34", "35–44", "45–54", "55–64", "Over 64"], id: \ .self) { age in
                    Button(action: { selectedAge = age }) {
                        HStack {
                            Text(age)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            if selectedAge == age {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(selectedAge == age ? 0.4 : 0.2))
                        .cornerRadius(16)
                    }
                }
            }
            Spacer()
        }
    }
    
    // Slide 4: Journaling time preference
    private var journalingTimeStep: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 16)
            Text("When do you want to carve out time for journaling?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text("You're most likely to form a healthy habit with 3 daily notifications.")
                .font(.system(size: 18))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
            VStack(spacing: 20) {
                ForEach([("Morning", "8:00 AM"), ("During the Day", "2:30 PM"), ("Evening", "9:00 PM")], id: \ .0) { (label, time) in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(label)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                            Text(time)
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { journalingTimes[label, default: false] },
                            set: { journalingTimes[label] = $0 }
                        ))
                        .toggleStyle(SwitchToggleStyle(tint: Color.white))
                        .labelsHidden()
                    }
                    .padding()
                    .background(Color.gray.opacity(journalingTimes[label, default: false] ? 0.4 : 0.2))
                    .cornerRadius(16)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
} 
