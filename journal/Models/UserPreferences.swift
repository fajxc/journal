import Foundation

class UserPreferences: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    @Published var selectedPhilosopher: String {
        didSet {
            UserDefaults.standard.set(selectedPhilosopher, forKey: "selectedPhilosopher")
        }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    
    @Published var reminderTime: Date {
        didSet {
            UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        self.selectedPhilosopher = UserDefaults.standard.string(forKey: "selectedPhilosopher") ?? "Marcus Aurelius"
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.reminderTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date ?? Date()
    }
} 