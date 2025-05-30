import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatView: View {
    @AppStorage("selectedPhilosopher") private var philosopher = "Marcus Aurelius"
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @State private var isTyping = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            VStack(spacing: 4) {
                Text(philosopher)
                    .font(.headline)
                Text("Stoic Philosopher")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // Messages
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(
                            message: message,
                            dateFormatter: dateFormatter
                        )
                    }
                    
                    if isTyping {
                        HStack {
                            Text("Typing")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TypingIndicator()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            
            // Input area
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    TextField("Ask anything...", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(newMessage.isEmpty ? .gray : .blue)
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
        }
        .preferredColorScheme(.dark)
    }
    
    private func sendMessage() {
        let userMessage = Message(content: newMessage, isUser: true, timestamp: Date())
        messages.append(userMessage)
        newMessage = ""
        
        // Simulate AI response
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            let response = generatePhilosopherResponse()
            let aiMessage = Message(content: response, isUser: false, timestamp: Date())
            messages.append(aiMessage)
        }
    }
    
    private func generatePhilosopherResponse() -> String {
        let responses = [
            "Remember that very little is needed to make a happy life.",
            "The happiness of your life depends upon the quality of your thoughts.",
            "Waste no more time arguing about what a good person should be. Be one.",
            "The best revenge is to be unlike him who performed the injury.",
            "Accept the things to which fate binds you, and love the people with whom fate brings you together."
        ]
        return responses.randomElement() ?? ""
    }
}

struct MessageBubble: View {
    let message: Message
    let dateFormatter: DateFormatter
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(18)
                
                Text(dateFormatter.string(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var phase = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 6, height: 6)
                    .opacity(phase == index ? 0.5 : 1.0)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever()) {
                phase = (phase + 1) % 3
            }
        }
    }
}

#Preview {
    ChatView()
} 