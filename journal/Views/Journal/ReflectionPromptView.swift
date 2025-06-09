import SwiftUI

struct ReflectionPromptView: View {
    let topic: ReflectionTopic
    @State private var selectedPrompt: ReflectionPrompt?
    @State private var appearAnimation = false
    @State private var selectedPromptAnimation = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(topic.prompts) { prompt in
                        PromptCard(prompt: prompt, isSelected: selectedPrompt?.id == prompt.id)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedPrompt = prompt
                                    selectedPromptAnimation = true
                                }
                            }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 20)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedPrompt) { prompt in
            NavigationStack {
                JournalEntryView(prompt: prompt)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                appearAnimation = true
            }
        }
    }
}

struct PromptCard: View {
    let prompt: ReflectionPrompt
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(prompt.shortTitle)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
            
            Text(prompt.fullPrompt)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.6))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    NavigationStack {
        ReflectionPromptView(topic: ReflectionData.topics[0])
    }
} 