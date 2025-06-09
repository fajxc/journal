import SwiftUI

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    func addEntry(_ entry: JournalEntry) {
        entries.insert(entry, at: 0)
        // Update insights view model
        NotificationCenter.default.post(name: .newJournalEntry, object: entry)
    }
}

struct JournalView: View {
    @EnvironmentObject private var viewModel: JournalViewModel
    @State private var showingNewEntry = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    @EnvironmentObject private var tabViewModel: MainTabViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        if viewModel.entries.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "book.closed.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(Color.white.opacity(0.4))
                                Text("No entries yet")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                Button(action: { showingNewEntry = true }) {
                                    Text("Start Writing")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(16)
                                }
                                .padding(.top, 20)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        } else {
                            ForEach(viewModel.entries) { entry in
                                JournalEntryRow(entry: entry)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
            }
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                ReflectionTopicView(isPresented: $showingNewEntry)
                    .environmentObject(viewModel)
                    .environmentObject(tabViewModel)
            }
        }
    }
}

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let content: String
    let mood: String
    let prompt: ReflectionPrompt?
    
    init(date: Date = Date(), title: String, content: String, mood: String, prompt: ReflectionPrompt? = nil) {
        self.date = date
        self.title = title
        self.content = content
        self.mood = mood
        self.prompt = prompt
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text(dateFormatter.string(from: entry.date))
                    .font(.system(size: 15))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            if let prompt = entry.prompt {
                Text(prompt.shortTitle)
                    .font(.system(size: 15))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            Text(entry.content)
                .font(.system(size: 17))
                .foregroundColor(Color.white.opacity(0.8))
                .lineLimit(3)
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(moodColor(for: entry.mood))
                Text(entry.mood.capitalized)
                    .font(.system(size: 15))
                    .foregroundColor(Color.white.opacity(0.7))
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.04))
        .cornerRadius(16)
    }
    private func moodColor(for mood: String) -> Color {
        switch mood.lowercased() {
        case "very positive": return .green
        case "positive": return .blue
        case "neutral": return Color.white.opacity(0.5)
        case "negative": return .orange
        case "very negative": return .red
        default: return Color.white.opacity(0.5)
        }
    }
}

// Notification to update insights
extension Notification.Name {
    static let newJournalEntry = Notification.Name("newJournalEntry")
}

#Preview {
    JournalView()
        .environmentObject(MainTabViewModel())
} 