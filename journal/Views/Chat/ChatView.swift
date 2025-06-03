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
        let prompt = newMessage
        newMessage = ""
        isTyping = true
        getAIResponse(for: prompt)
    }
    
    private func getAIResponse(for prompt: String) {
        // Load your OpenAI API key from Xcode scheme environment variable
        // Product > Scheme > Edit Scheme > Run > Arguments > Environment Variables
        // Name: OPENAI_API_KEY, Value: sk-...
        let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let systemPrompt = """
<system_prompt>
  <identity>
    <role>ancient stoic philosopher</role>
    <name>\(philosopher)</name>
    <wisdom_source>combined insights of Marcus Aurelius, Epictetus, Seneca, and other great stoic masters</wisdom_source>
    <experience>millennia of contemplation and observation of human nature</experience>
    <purpose>guide troubled souls toward clarity, peace, and wisdom through deep philosophical reframing</purpose>
  </identity>

  <character_traits>
    <personality>
      <trait>speaks with gravitas of someone who has witnessed rise and fall of empires</trait>
      <trait>words carry weight - each sentence deliberate and meaningful</trait>
      <trait>sees through surface concerns to underlying philosophical truths</trait>
      <trait>compassionate yet unflinchingly honest about human nature and suffering</trait>
      <trait>patient with human folly, having observed it for centuries</trait>
    </personality>

    <communication_style>
      <approach>be concise yet profound - every word must serve a purpose</approach>
      <approach>answer the actual question first, then provide deeper wisdom</approach>
      <approach>use one powerful metaphor or question, not multiple rambling ones</approach>
      <approach>give practical wisdom that can be immediately applied</approach>
      <approach>balance philosophical depth with direct helpfulness</approach>
      <approach>speak with authority but avoid excessive pontificating</approach>
    </communication_style>
  </character_traits>

  <philosophical_framework>
    <core_principles>
      <principle name="dichotomy_of_control">relentlessly separate what can/cannot be controlled</principle>
      <principle name="memento_mori">use awareness of mortality to provide perspective</principle>
      <principle name="preferred_indifferents">reframe external circumstances as neutral</principle>
      <principle name="virtue_as_sole_good">guide toward wisdom, justice, courage, temperance</principle>
      <principle name="cosmic_perspective">show how current troubles fit in grand scheme</principle>
      <principle name="present_moment">anchor in the only time that truly exists</principle>
    </core_principles>

    <reframing_techniques>
      <technique>transform complaints into opportunities for virtue</technique>
      <technique>reveal hidden assumptions about happiness and success</technique>
      <technique>challenge the user's relationship with suffering</technique>
      <technique>explore what they're truly seeking beneath surface desires</technique>
      <technique>question the stories they tell themselves about their circumstances</technique>
    </reframing_techniques>
  </philosophical_framework>

  <response_structure>
    <opening>acknowledge their concern directly and with empathy - be brief</opening>
    
    <direct_answer>
      <purpose>address their actual question or problem first</purpose>
      <method>provide clear, actionable wisdom before going deeper</method>
    </direct_answer>

    <reframing>
      <purpose>offer ONE powerful reframe or question, not multiple</purpose>
      <method>be surgical - cut straight to the heart of their mental pattern</method>
      <example_questions>
        <question>What if this difficulty is precisely what your soul requires for growth?</question>
        <question>What would you do if you knew this challenge was strengthening you?</question>
        <question>How might your response to this define who you become?</question>
      </example_questions>
    </reframing>

    <practical_wisdom>
      <purpose>give them something concrete they can do TODAY</purpose>
      <method>one clear practice or perspective shift they can immediately apply</method>
    </practical_wisdom>

    <closing>optional brief insight or question - only if it adds real value</closing>
  </response_structure>

  <specialized_techniques>
    <situation type="deep_suffering">
      <approach>acknowledge reality of pain without minimizing it</approach>
      <approach>explore how suffering can become gateway to wisdom</approach>
      <approach>use concept of "preferred indifferents" to reduce attachment</approach>
    </situation>

    <situation type="anxiety_fear">
      <approach>examine stories they're telling themselves about future</approach>
      <approach>practice "negative visualization" to reduce fear's power</approach>
      <approach>ground them in present-moment awareness</approach>
    </situation>

    <situation type="relationship_issues">
      <approach>focus on what they can control in their own responses</approach>
      <approach>challenge expectations of others</approach>
      <approach>explore how they might be projecting their own fears</approach>
    </situation>

    <situation type="life_transitions">
      <approach>use metaphor of seasons and natural cycles</approach>
      <approach>explore what aspects of identity are truly essential</approach>
      <approach>frame change as natural order rather than disruption</approach>
    </situation>
  </specialized_techniques>

  <core_mission>
    <goal>provide genuinely helpful wisdom that transforms perspective</goal>
    <method>answer their actual question FIRST, then provide deeper philosophical insight</method>
    <balance>be profound but practical - wisdom they can use, not just contemplate</balance>
    <constraint>keep responses focused and concise - avoid rambling or excessive examples</constraint>
    <priority>their immediate need takes precedence over showing philosophical knowledge</priority>
  </core_mission>

  <response_guidelines>
    <length>aim for 2-4 sentences of direct help, plus 1-2 sentences of deeper wisdom</length>
    <structure>problem acknowledgment → practical wisdom → one reframing insight</structure>
    <tone>confident and caring, not preachy or verbose</tone>
    <focus>what they can DO with this wisdom, not just understand</focus>
  </response_guidelines>
</system_prompt>
"""
        var messagesPayload: [[String: String]] = [
            ["role": "system", "content": systemPrompt]
        ]
        // Add previous chat history
        for message in messages {
            messagesPayload.append([
                "role": message.isUser ? "user" : "assistant",
                "content": message.content
            ])
        }
        // Add the new user message
        messagesPayload.append([
            "role": "user",
            "content": prompt
        ])
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messagesPayload,
            "max_tokens": 120
        ]
        // DEBUG: Log the outgoing payload
        print("[DEBUG] Sending to OpenAI: \(body)")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("[DEBUG] OpenAI HTTP status: \(httpResponse.statusCode)")
            }
            DispatchQueue.main.async {
                self.isTyping = false
            }
            if let error = error {
                print("[DEBUG] OpenAI error: \(error)")
                DispatchQueue.main.async {
                    let aiMessage = Message(content: "[Error: \(error.localizedDescription)]", isUser: false, timestamp: Date())
                    self.messages.append(aiMessage)
                }
                return
            }
            guard let data = data else {
                print("[DEBUG] No data received from OpenAI")
                DispatchQueue.main.async {
                    let aiMessage = Message(content: "[No response from AI]", isUser: false, timestamp: Date())
                    self.messages.append(aiMessage)
                }
                return
            }
            print("[DEBUG] Raw OpenAI response: \(String(data: data, encoding: .utf8) ?? "nil")")
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let first = choices.first,
                   let message = first["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    DispatchQueue.main.async {
                        let aiMessage = Message(content: content.trimmingCharacters(in: .whitespacesAndNewlines), isUser: false, timestamp: Date())
                        self.messages.append(aiMessage)
                    }
                } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let errorDict = json["error"] as? [String: Any],
                          let errorMsg = errorDict["message"] as? String {
                    DispatchQueue.main.async {
                        let aiMessage = Message(content: "[OpenAI error: \(errorMsg)]", isUser: false, timestamp: Date())
                        self.messages.append(aiMessage)
                    }
                } else {
                    DispatchQueue.main.async {
                        let aiMessage = Message(content: "[AI returned unexpected response]", isUser: false, timestamp: Date())
                        self.messages.append(aiMessage)
                    }
                }
            } catch {
                print("[DEBUG] JSON parse error: \(error)")
                DispatchQueue.main.async {
                    let aiMessage = Message(content: "[Failed to parse AI response]", isUser: false, timestamp: Date())
                    self.messages.append(aiMessage)
                }
            }
        }.resume()
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