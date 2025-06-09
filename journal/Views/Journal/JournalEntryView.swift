import SwiftUI
import Combine

struct JournalEntryView: View {
    let prompt: ReflectionPrompt
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var journalViewModel: JournalViewModel
    @EnvironmentObject private var tabViewModel: MainTabViewModel
    
    @State private var title = ""
    @State private var content = ""
    @State private var mood: String = "neutral"
    @State private var appearAnimation = false
    @State private var isSaving = false
    
    let moods = ["very negative", "negative", "neutral", "positive", "very positive"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    PromptHeader(prompt: prompt)
                    
                    VStack(spacing: 16) {
                        TextField("title", text: $title)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            .submitLabel(.next)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                        
                        TextEditor(text: $content)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(minHeight: 200)
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            .submitLabel(.done)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.sentences)
                        
                        // Mood Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("mood")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            HStack(spacing: 8) {
                                ForEach(moods, id: \ .self) { m in
                                    Button(action: { mood = m }) {
                                        Text(m.capitalized)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(mood == m ? .black : .white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(mood == m ? Color.white : Color.white.opacity(0.13))
                                            .cornerRadius(14)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(24)
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 20)
            }
        }
        .navigationTitle("new entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: saveEntry) {
                    if isSaving {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("save")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .disabled(title.isEmpty || content.isEmpty || isSaving)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                appearAnimation = true
            }
        }
    }
    
    private func saveEntry() {
        isSaving = true
        let entry = JournalEntry(
            date: Date(),
            title: title,
            content: content,
            mood: mood,
            prompt: prompt
        )
        Task {
            do {
                try await journalViewModel.addEntry(entry)
                await MainActor.run {
                    tabViewModel.selectedTab = .home
                    dismiss()
                }
            } catch {
                print("Error saving entry: \(error)")
                isSaving = false
            }
        }
    }
}

struct PromptHeader: View {
    let prompt: ReflectionPrompt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(prompt.shortTitle)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(prompt.fullPrompt)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.6))
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        JournalEntryView(prompt: ReflectionData.topics[0].prompts[0])
            .environmentObject(JournalViewModel())
            .environmentObject(MainTabViewModel())
    }
} 