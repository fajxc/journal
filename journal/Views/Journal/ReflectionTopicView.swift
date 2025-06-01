import SwiftUI

struct ReflectionTopicView: View {
    @Binding var isPresented: Bool
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
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isPresented = false
                        }
                    }) {
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
                        .transition(.opacity.combined(with: .scale))
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
    ReflectionTopicView(isPresented: .constant(true))
        .environmentObject(JournalViewModel())
} 