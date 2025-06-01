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
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.entries.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Theme.textSecondary)
                            Text("no entries yet")
                                .font(Theme.bodyStyle)
                                .foregroundColor(Theme.textSecondary)
                            
                            Button(action: { showingNewEntry = true }) {
                                Text("start writing")
                                    .font(Theme.bodyStyle)
                                    .foregroundColor(Theme.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Theme.buttonStyle(isProminent: true))
                                    .cornerRadius(Theme.cornerRadius)
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
                .padding()
            }
            .background(Theme.backgroundColor)
            .navigationTitle("journal")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(Theme.accentColor)
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
                    .font(Theme.bodyStyle)
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text(dateFormatter.string(from: entry.date))
                    .font(Theme.captionStyle)
                    .foregroundColor(Theme.textSecondary)
            }
            
            if let prompt = entry.prompt {
                Text(prompt.shortTitle)
                    .font(Theme.captionStyle)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Text(entry.content)
                .font(Theme.bodyStyle)
                .foregroundColor(Theme.textSecondary)
                .lineLimit(3)
            
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(moodColor(for: entry.mood))
                Text(entry.mood)
                    .font(Theme.captionStyle)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func moodColor(for mood: String) -> Color {
        switch mood.lowercased() {
        case "very positive": return .green
        case "positive": return .blue
        case "neutral": return Theme.textSecondary
        case "negative": return .orange
        case "very negative": return .red
        default: return Theme.textSecondary
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