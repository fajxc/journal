import SwiftUI

struct ReflectionTopicView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTopic: ReflectionTopic?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(ReflectionData.topics) { topic in
                        NavigationLink(destination: ReflectionPromptView(topic: topic)) {
                            TopicCard(topic: topic)
                        }
                    }
                }
                .padding(Theme.screenPadding)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("choose a topic")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Theme.textSecondary)
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

struct TopicCard: View {
    let topic: ReflectionTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(topic.title)
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
    ReflectionTopicView()
        .environmentObject(JournalViewModel())
} 