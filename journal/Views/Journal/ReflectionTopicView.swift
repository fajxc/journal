import SwiftUI

struct ReflectionTopicView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTopic: ReflectionTopic?
    @State private var appearAnimation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(ReflectionData.topics) { topic in
                            NavigationLink(destination: ReflectionPromptView(topic: topic)) {
                                TopicCard(topic: topic)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 20)
                }
            }
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
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                appearAnimation = true
            }
        }
    }
}

struct TopicCard: View {
    let topic: ReflectionTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(topic.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text("\(topic.prompts.count) prompts")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.6))
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
        .contentShape(Rectangle())
    }
}

#Preview {
    ReflectionTopicView(isPresented: .constant(true))
        .environmentObject(JournalViewModel())
} 