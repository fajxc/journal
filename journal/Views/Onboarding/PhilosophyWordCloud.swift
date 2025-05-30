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
            // Header section
            VStack(alignment: .leading, spacing: 24) {
                // Title and subtitles
                VStack(alignment: .leading, spacing: 8) {
                    Text("select what resonates")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Select 3-5 words that resonate with you")
                        .font(.system(size: 20))
                        .foregroundColor(Theme.textSecondary)
                    
                    Text("These words will help match you with a philosophical guide")
                        .font(.system(size: 17))
                        .foregroundColor(Theme.textSecondary)
                        .padding(.top, 8)
                }
                
                // Selection counter and clear button
                HStack {
                    Text("Selected: \(selectedTraits.count)/5")
                        .foregroundColor(selectedTraits.isEmpty ? .orange : .green)
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    if !selectedTraits.isEmpty {
                        Button(action: { selectedTraits.removeAll() }) {
                            Text("Clear")
                                .font(.system(size: 17))
                                .foregroundColor(Theme.textSecondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(white: 0.3))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Traits grid with fixed height
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100), spacing: 8)
            ], alignment: .leading, spacing: 12) {
                ForEach(traits) { trait in
                    TraitButton(
                        text: trait.word,
                        isSelected: selectedTraits.contains(trait.word),
                        action: { toggleTrait(trait.word) }
                    )
                }
            }
            .padding()
            
            Spacer(minLength: 20)
            
            // Selected traits descriptions
            if !selectedTraits.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("About your selections:")
                        .font(.system(size: 17))
                        .foregroundColor(Theme.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(traits.filter { selectedTraits.contains($0.word) }) { trait in
                            HStack(alignment: .top, spacing: 4) {
                                Text("•")
                                    .foregroundColor(Theme.textPrimary)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(trait.word)
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    Text(trait.description)
                                        .font(.system(size: 15))
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(white: 0.15))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            Spacer(minLength: 20)
            
            // Progress and navigation
            VStack(spacing: 16) {
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        Capsule()
                            .fill(index == 3 ? Theme.textPrimary : Theme.textSecondary.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal)
                
                // Navigation buttons
                HStack {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Continue")
                            .foregroundColor(Theme.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(white: 0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Theme.backgroundColor)
    }
    
    private func toggleTrait(_ trait: String) {
        if selectedTraits.contains(trait) {
            selectedTraits.remove(trait)
        } else if selectedTraits.count < maxSelections {
            selectedTraits.insert(trait)
        }
    }
}

struct TraitButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(text)
                    .font(.system(size: 17))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .foregroundColor(isSelected ? Theme.textPrimary : Theme.textSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(height: 36)
            .background(
                Capsule()
                    .fill(isSelected ? Color(white: 0.3) : Color.clear)
                    .overlay(
                        Capsule()
                            .strokeBorder(isSelected ? Color.clear : Color(white: 0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    PhilosophyWordCloud(selectedTraits: .constant(Set(["Rational", "Curious", "Grounded"])))
        .background(Theme.backgroundColor)
        .preferredColorScheme(.dark)
} 