import SwiftUI

struct JournalView: View {
    @State private var entries: [JournalEntry] = []
    @State private var showingNewEntry = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entries) { entry in
                    JournalEntryRow(entry: entry)
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NewJournalEntryView(entries: $entries)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let content: String
    let mood: String
}

struct JournalEntryRow: View {
    let entry: JournalEntry
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.title)
                    .font(.headline)
                Spacer()
                Text(dateFormatter.string(from: entry.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(entry.content)
                .font(.body)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text(entry.mood)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

struct NewJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var entries: [JournalEntry]
    @State private var title = ""
    @State private var content = ""
    @State private var mood = "Neutral"
    
    let moods = ["Happy", "Grateful", "Neutral", "Anxious", "Sad"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Entry title", text: $title)
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
                
                Section(header: Text("Mood")) {
                    Picker("Select mood", selection: $mood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood).tag(mood)
                        }
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let entry = JournalEntry(
                            date: Date(),
                            title: title,
                            content: content,
                            mood: mood
                        )
                        entries.insert(entry, at: 0)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    JournalView()
} 