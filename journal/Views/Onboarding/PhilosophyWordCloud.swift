import SwiftUI

struct PhilosophyTrait: Identifiable {
    let id = UUID()
    let word: String
    let description: String
}

struct PhilosophyWordCloud: View {
    @Binding var selectedTraits: Set<String>
    @State private var maxSelections = 5
    
    private let traits = [
        PhilosophyTrait(word: "Stoic", description: "Maintaining calm in adversity"),
        PhilosophyTrait(word: "Analytical", description: "Breaking down complex ideas"),
        PhilosophyTrait(word: "Empathetic", description: "Understanding others' feelings"),
        PhilosophyTrait(word: "Minimalist", description: "Finding beauty in simplicity"),
        PhilosophyTrait(word: "Resilient", description: "Bouncing back from challenges"),
        PhilosophyTrait(word: "Present-minded", description: "Living in the moment"),
        PhilosophyTrait(word: "Rational", description: "Using reason to guide decisions"),
        PhilosophyTrait(word: "Spiritual", description: "Connected to deeper meaning"),
        PhilosophyTrait(word: "Detached", description: "Free from attachments"),
        PhilosophyTrait(word: "Curious", description: "Always seeking knowledge"),
        PhilosophyTrait(word: "Grounded", description: "Firmly rooted in reality"),
        PhilosophyTrait(word: "Purpose-driven", description: "Living with intention"),
        PhilosophyTrait(word: "Balanced", description: "Finding harmony in life"),
        PhilosophyTrait(word: "Virtuous", description: "Living by moral principles"),
        PhilosophyTrait(word: "Practical", description: "Focused on what works"),
        PhilosophyTrait(word: "Honest", description: "True to oneself and others"),
        PhilosophyTrait(word: "Rebellious", description: "Challenging conventions"),
        PhilosophyTrait(word: "Logical", description: "Following sound reasoning"),
        PhilosophyTrait(word: "Naturalistic", description: "In harmony with nature")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 24)
            VStack(spacing: 16) {
                Text("Select what resonates")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Pick 3–5 traits that resonate with you")
                    .font(.system(size: 18))
                    .foregroundColor(Color.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
            ScrollView {
                VStack(spacing: 24) {
                    // Trait chips
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
                        ForEach(traits) { trait in
                            TraitChip(
                                text: trait.word,
                                isSelected: selectedTraits.contains(trait.word),
                                action: { toggleTrait(trait.word) },
                                isDisabled: !selectedTraits.contains(trait.word) && selectedTraits.count >= maxSelections
                            )
                        }
                    }
                    .padding(.top, 8)
                    // Selected trait descriptions
                    if !selectedTraits.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About your selections:")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                            ForEach(traits.filter { selectedTraits.contains($0.word) }) { trait in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(trait.word)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text(trait.description)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.white.opacity(0.7))
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(16)
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            Spacer(minLength: 0)
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    private func toggleTrait(_ trait: String) {
        if selectedTraits.contains(trait) {
            selectedTraits.remove(trait)
        } else if selectedTraits.count < maxSelections {
            selectedTraits.insert(trait)
        }
    }
}

struct TraitChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    let isDisabled: Bool
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(text)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .black : .white)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isSelected ? Color.white : Color.white.opacity(0.13))
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isSelected ? Color.white : Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.4 : 1.0)
    }
}

#Preview {
    PhilosophyWordCloud(selectedTraits: .constant(Set(["Rational", "Curious", "Grounded"])))
        .background(Theme.backgroundColor)
        .preferredColorScheme(.dark)
} 