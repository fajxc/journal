import SwiftUI

struct JournalEntryView: View {
    let prompt: ReflectionPrompt
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var mood: Mood = .neutral
    @EnvironmentObject private var viewModel: JournalViewModel
    @EnvironmentObject private var tabViewModel: MainTabViewModel
    
    enum Mood: String, CaseIterable {
        case veryNegative = "very negative"
        case negative = "negative"
        case neutral = "neutral"
        case positive = "positive"
        case veryPositive = "very positive"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(prompt.fullPrompt)
                    .font(Theme.bodyStyle)
                    .foregroundColor(Theme.textSecondary)
                    .padding(.top, Theme.screenPadding)
                
                TextField("title", text: $title)
                    .font(Theme.bodyStyle)
                    .textFieldStyle(CustomTextFieldStyle())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("mood")
                        .font(Theme.captionStyle)
                        .foregroundColor(Theme.textSecondary)
                    
                    HStack(spacing: 8) {
                        ForEach(Mood.allCases, id: \.self) { currentMood in
                            Button(action: { mood = currentMood }) {
                                Text(currentMood.rawValue)
                                    .font(Theme.captionStyle)
                                    .foregroundColor(mood == currentMood ? Theme.textPrimary : Theme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                            .fill(mood == currentMood ? Theme.accentColor : Theme.cardBackground)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                            .stroke(mood == currentMood ? Theme.accentColor : Theme.textSecondary.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $content)
                        .font(Theme.bodyStyle)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 200)
                        .padding()
                        .background(Theme.cardBackground.opacity(0.4))
                        .cornerRadius(Theme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                    
                    if content.isEmpty {
                        Text("write your thoughts...")
                            .font(Theme.bodyStyle)
                            .foregroundColor(Theme.textSecondary.opacity(0.6))
                            .padding(.horizontal)
                            .padding(.vertical, 24)
                            .allowsHitTesting(false)
                    }
                }
                
                Button(action: saveEntry) {
                    Text("save entry")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.buttonStyle(isProminent: true))
                        .cornerRadius(Theme.cornerRadius)
                }
                .disabled(title.isEmpty || content.isEmpty)
                .padding(.top, 20)
            }
            .padding(Theme.screenPadding)
        }
        .background(Theme.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveEntry() {
        let entry = JournalEntry(
            title: title,
            content: content,
            mood: mood.rawValue,
            prompt: prompt
        )
        viewModel.addEntry(entry)
        
        // Switch to insights tab
        tabViewModel.selectedTab = .insights
        dismiss()
    }
}

#Preview {
    NavigationStack {
        JournalEntryView(prompt: ReflectionData.topics[0].prompts[0])
            .environmentObject(JournalViewModel())
            .environmentObject(MainTabViewModel())
    }
} 