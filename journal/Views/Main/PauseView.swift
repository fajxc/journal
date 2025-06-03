import SwiftUI

struct PauseView: View {
    let quotes: [Quote] = [
        Quote(text: "He who fears death will never do anything worth of a man who is alive.", author: "Seneca"),
        Quote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius"),
        Quote(text: "We suffer more often in imagination than in reality.", author: "Seneca"),
        Quote(text: "It is not that we have a short time to live, but that we waste a lot of it.", author: "Seneca"),
        Quote(text: "You have power over your mind – not outside events. Realize this, and you will find strength.", author: "Marcus Aurelius"),
        Quote(text: "Man conquers the world by conquering himself.", author: "Zeno of Citium")
    ]
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var showJournalEntry = false
    @State private var selectedPrompt: ReflectionPrompt? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(quotes.indices, id: \.self) { i in
                    if abs(i - currentIndex) <= 1 {
                        QuoteCard(
                            quote: quotes[i],
                            onPrompt: {
                                print("[DEBUG] Reflect button tapped for quote: \(quotes[i].text)")
                                selectedPrompt = ReflectionPrompt(shortTitle: quotes[i].text, fullPrompt: quotes[i].text)
                                print("[DEBUG] selectedPrompt set: \(selectedPrompt?.shortTitle ?? "nil")")
                                showJournalEntry = true
                                print("[DEBUG] showJournalEntry set to true")
                            }
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: CGFloat(i - currentIndex) * geometry.size.height + dragOffset)
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: currentIndex)
                    } else {
                        EmptyView()
                    }
                }
            }
            .background(Theme.backgroundColor)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let threshold = geometry.size.height / 4
                        if value.translation.height < -threshold && currentIndex < quotes.count - 1 {
                            currentIndex += 1
                        } else if value.translation.height > threshold && currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
            )
            .sheet(isPresented: $showJournalEntry, onDismiss: {
                print("[DEBUG] JournalEntryView sheet dismissed")
            }) {
                if let prompt = selectedPrompt {
                    JournalEntryView(prompt: prompt)
                        .environmentObject(JournalViewModel())
                        .environmentObject(MainTabViewModel())
                        .onAppear {
                            print("[DEBUG] Presenting JournalEntryView with prompt: \(prompt.shortTitle)")
                        }
                } else {
                    EmptyView()
                        .onAppear {
                            print("[DEBUG] selectedPrompt is nil when presenting sheet")
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
}

struct QuoteCard: View {
    let quote: Quote
    var onPrompt: (() -> Void)? = nil
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("\u{201C}\(quote.text)\u{201D}")
                .font(.system(size: 28, weight: .semibold, design: .serif))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Text("– \(quote.author)")
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
            Button(action: {
                print("[DEBUG] QuoteCard Reflect button pressed")
                onPrompt?()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "square.and.pencil")
                        .font(.subheadline)
                    Text("Reflect")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(Color.white.opacity(0.12))
                .cornerRadius(16)
                .shadow(radius: 2)
            }
            .padding(.top, 4)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor)
    }
}

#Preview {
    PauseView()
} 