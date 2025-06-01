import SwiftUI

struct ReflectionPromptView: View {
    let topic: ReflectionTopic
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(topic.prompts) { prompt in
                    NavigationLink(destination: JournalEntryView(prompt: prompt)) {
                        PromptCard(prompt: prompt)
                    }
                }
            }
            .padding(Theme.screenPadding)
        }
        .background(Theme.backgroundColor)
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .tint(Theme.textSecondary)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Theme.textSecondary)
                            .imageScale(.large)
                        Text("home")
                            .foregroundColor(Theme.textSecondary)
                            .font(Theme.bodyStyle)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.clear)
                }
            }
        }
    }
}

struct PromptCard: View {
    let prompt: ReflectionPrompt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(prompt.shortTitle)
                .font(Theme.bodyStyle)
                .foregroundColor(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Theme.screenPadding)
        }
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
}

#Preview {
    NavigationStack {
        ReflectionPromptView(topic: ReflectionData.topics[0])
    }
} 