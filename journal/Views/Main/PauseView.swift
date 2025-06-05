import SwiftUI

struct APIQuote: Decodable, Identifiable {
    let id: String
    let quote: String
    let year: String?
    let work: String?
    let philosopher: Philosopher?
    
    struct Philosopher: Decodable {
        let id: String
    }
}

struct PauseView: View {
    @State private var quotes: [Quote] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var showJournalEntry = false
    @State private var selectedPrompt: ReflectionPrompt? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isLoading {
                    ProgressView("Loading quotes...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if let errorMessage = errorMessage {
                    VStack {
                        Text("Failed to load quotes")
                            .foregroundColor(.white)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                        Button("Retry") {
                            Task { await fetchQuotes() }
                        }
                        .padding(.top, 8)
                    }
                } else if quotes.isEmpty {
                    Text("No quotes available.")
                        .foregroundColor(.white)
                } else {
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
                            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: currentIndex)
                        } else {
                            EmptyView()
                        }
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
                        let threshold = geometry.size.height / 8
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
            .task {
                await fetchQuotes()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func fetchQuotes() async {
        isLoading = true
        errorMessage = nil
        do {
            guard let url = URL(string: "https://philosophersapi.com/api/quotes") else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                errorMessage = "Server error"
                isLoading = false
                return
            }
            let apiQuotes = try JSONDecoder().decode([APIQuote].self, from: data)
            let mappedQuotes = apiQuotes.map { apiQuote in
                Quote(text: apiQuote.quote, author: authorName(from: apiQuote))
            }
            quotes = mappedQuotes
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func authorName(from apiQuote: APIQuote) -> String {
        // Simple mapping for demonstration purposes
        let philosopherNames: [String: String] = [
            "F8320389-19D4-4095-95A3-A93A7F7F7997": "Heraclitus",
            "73E6F183-7335-458F-883E-83A9A8F9E562": "Parmenides",
            "0506F72D-FCD9-4F55-BD23-38953ADD2F88": "David Hume",
            "8D0D5B08-94A1-401D-AF81-25377AEE86DA": "Immanuel Kant",
            "1180AEE2-37F0-4A03-A2F0-F8F63DD7A5E2": "Georg Wilhelm Friedrich Hegel",
            "BB4F146D-92C5-4E69-B6B4-F1F946C84377": "Jean-Jacques Rousseau"
        ]
        return philosopherNames[apiQuote.philosopher?.id ?? ""] ?? "Unknown"
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