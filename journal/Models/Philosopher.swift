import Foundation

struct Philosopher: Identifiable, Codable {
    let id: UUID
    let name: String
    let title: String
    let era: String
    let philosophy: String
    let quotes: [String]
    
    static let philosophers = [
        Philosopher(
            id: UUID(),
            name: "Marcus Aurelius",
            title: "Roman Emperor and Stoic Philosopher",
            era: "121-180 CE",
            philosophy: "Stoicism",
            quotes: [
                "The happiness of your life depends upon the quality of your thoughts.",
                "Waste no more time arguing about what a good person should be. Be one.",
                "Everything we hear is an opinion, not a fact. Everything we see is a perspective, not the truth.",
                "Very little is needed to make a happy life; it is all within yourself, in your way of thinking.",
                "When you arise in the morning, think of what a precious privilege it is to be alive - to breathe, to think, to enjoy, to love."
            ]
        ),
        Philosopher(
            id: UUID(),
            name: "Seneca",
            title: "Roman Stoic Philosopher",
            era: "4 BCE - 65 CE",
            philosophy: "Stoicism",
            quotes: [
                "We suffer more often in imagination than in reality.",
                "Luck is what happens when preparation meets opportunity.",
                "As is a tale, so is life: not how long it is, but how good it is, is what matters.",
                "The greatest blessings of mankind are within us and within our reach.",
                "Life is long if you know how to use it."
            ]
        ),
        Philosopher(
            id: UUID(),
            name: "Epictetus",
            title: "Greek Stoic Philosopher",
            era: "50-135 CE",
            philosophy: "Stoicism",
            quotes: [
                "It's not what happens to you, but how you react to it that matters.",
                "First say to yourself what you would be; then do what you have to do.",
                "The key is to keep company only with people who uplift you.",
                "No man is free who is not master of himself.",
                "Don't explain your philosophy. Embody it."
            ]
        )
    ]
    
    static func getRandomQuote(for philosopherName: String) -> String {
        guard let philosopher = philosophers.first(where: { $0.name == philosopherName }) else {
            return "Wisdom comes from within."
        }
        return philosopher.quotes.randomElement() ?? "Wisdom comes from within."
    }
    
    static func getPhilosopher(by name: String) -> Philosopher? {
        return philosophers.first(where: { $0.name == name })
    }
    
    static func getPhilosopherForTrait(_ trait: String) -> Philosopher {
        switch trait.lowercased() {
        case "stoic":
            return philosophers[0] // Marcus Aurelius
        case "analytical":
            return philosophers[1] // Seneca
        default:
            return philosophers[2] // Epictetus
        }
    }
} 