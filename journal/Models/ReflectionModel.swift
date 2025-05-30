import Foundation

struct ReflectionTopic: Identifiable {
    let id = UUID()
    let title: String
    let prompts: [ReflectionPrompt]
}

struct ReflectionPrompt: Identifiable {
    let id = UUID()
    let shortTitle: String
    let fullPrompt: String
}

// Sample reflection data
struct ReflectionData {
    static let topics = [
        ReflectionTopic(title: "self-awareness", prompts: [
            ReflectionPrompt(
                shortTitle: "current state of mind",
                fullPrompt: "take a moment to observe your current state of mind. what thoughts and feelings are present?"
            ),
            ReflectionPrompt(
                shortTitle: "personal growth",
                fullPrompt: "what aspect of yourself would you like to understand better or improve?"
            ),
            ReflectionPrompt(
                shortTitle: "daily patterns",
                fullPrompt: "what patterns or habits have you noticed about yourself lately?"
            )
        ]),
        ReflectionTopic(title: "gratitude", prompts: [
            ReflectionPrompt(
                shortTitle: "simple joys",
                fullPrompt: "what's something simple that brought you joy today?"
            ),
            ReflectionPrompt(
                shortTitle: "helpful people",
                fullPrompt: "who made your life easier this week? how did they impact you?"
            ),
            ReflectionPrompt(
                shortTitle: "challenging growth",
                fullPrompt: "what challenge are you grateful for in hindsight? how did it help you grow?"
            )
        ]),
        ReflectionTopic(title: "emotional clarity", prompts: [
            ReflectionPrompt(
                shortTitle: "emotional awareness",
                fullPrompt: "what emotion has been most present in your life lately? how does it manifest?"
            ),
            ReflectionPrompt(
                shortTitle: "emotional triggers",
                fullPrompt: "what situations tend to trigger strong emotional responses in you?"
            ),
            ReflectionPrompt(
                shortTitle: "emotional balance",
                fullPrompt: "how do you maintain emotional balance in challenging situations?"
            )
        ]),
        ReflectionTopic(title: "values", prompts: [
            ReflectionPrompt(
                shortTitle: "core values",
                fullPrompt: "what values are most important to you? how do they guide your decisions?"
            ),
            ReflectionPrompt(
                shortTitle: "living values",
                fullPrompt: "how well are your current actions aligned with your core values?"
            ),
            ReflectionPrompt(
                shortTitle: "value conflicts",
                fullPrompt: "when have your values been challenged recently? how did you handle it?"
            )
        ]),
        ReflectionTopic(title: "fear & acceptance", prompts: [
            ReflectionPrompt(
                shortTitle: "current fears",
                fullPrompt: "what fears or anxieties are you currently facing? what lies beneath them?"
            ),
            ReflectionPrompt(
                shortTitle: "acceptance journey",
                fullPrompt: "what aspect of your life are you learning to accept? how has this process been?"
            ),
            ReflectionPrompt(
                shortTitle: "growth through fear",
                fullPrompt: "how has facing your fears contributed to your personal growth?"
            )
        ]),
        ReflectionTopic(title: "relationships", prompts: [
            ReflectionPrompt(
                shortTitle: "connection quality",
                fullPrompt: "how would you describe the quality of your relationships right now?"
            ),
            ReflectionPrompt(
                shortTitle: "relationship patterns",
                fullPrompt: "what patterns do you notice in your relationships? what might they reveal?"
            ),
            ReflectionPrompt(
                shortTitle: "boundaries",
                fullPrompt: "how well are you maintaining healthy boundaries in your relationships?"
            )
        ]),
        ReflectionTopic(title: "discipline", prompts: [
            ReflectionPrompt(
                shortTitle: "daily practice",
                fullPrompt: "what daily practices help you maintain discipline in your life?"
            ),
            ReflectionPrompt(
                shortTitle: "resistance",
                fullPrompt: "what do you resist most in your daily routine? why might that be?"
            ),
            ReflectionPrompt(
                shortTitle: "commitment",
                fullPrompt: "how do you stay committed to your goals when motivation fades?"
            )
        ])
    ]
} 