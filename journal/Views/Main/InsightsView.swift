import SwiftUI

class InsightsViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    init() {
        // Listen for new journal entries
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNewEntry),
            name: .newJournalEntry,
            object: nil
        )
    }
    
    @objc private func handleNewEntry(_ notification: Notification) {
        if let entry = notification.object as? JournalEntry {
            entries.insert(entry, at: 0)
        }
    }
    
    var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        
        // Get sorted dates of entries
        let sortedDates = entries.map { $0.date }.sorted(by: >)
        guard let lastEntry = sortedDates.first else { return 0 }
        
        // If last entry is not from today or yesterday, no streak
        if !calendar.isDateInToday(lastEntry) && !calendar.isDateInYesterday(lastEntry) {
            return 0
        }
        
        // Count consecutive days
        var currentDate = lastEntry
        var dateToCheck = currentDate
        
        while true {
            if let entryOnDate = sortedDates.first(where: { calendar.isDate($0, inSameDayAs: dateToCheck) }) {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: dateToCheck) else { break }
                dateToCheck = previousDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    var weeklyActivity: [Int] {
        let calendar = Calendar.current
        let today = Date()
        var activity = [0, 0, 0, 0, 0, 0, 0] // Sun-Sat
        
        // Get start of current week
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return activity
        }
        
        // Count entries for each day
        for entry in entries {
            guard let daysFromStart = calendar.dateComponents([.day], from: startOfWeek, to: entry.date).day,
                  daysFromStart >= 0 && daysFromStart < 7 else { continue }
            activity[daysFromStart] += 1
        }
        
        return activity
    }
}

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    @State private var showingLogoutAlert = false
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Insights")
                        .font(Theme.headerStyle)
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showingLogoutAlert = true }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(Theme.textSecondary)
                            .imageScale(.large)
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                
                // Stats cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "Current Streak",
                        value: "\(viewModel.currentStreak)",
                        unit: "days",
                        icon: "flame.fill"
                    )
                    
                    StatCard(
                        title: "Total Entries",
                        value: "\(viewModel.entries.count)",
                        unit: "notes",
                        icon: "book.fill"
                    )
                }
                .padding(.horizontal, Theme.screenPadding)
                
                // Activity graph
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weekly Activity")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textSecondary)
                    
                    GeometryReader { geometry in
                        HStack(alignment: .bottom, spacing: (geometry.size.width - 24 * 7) / 6) {
                            ForEach(Array(zip(weekdays, viewModel.weeklyActivity)), id: \.0) { day, count in
                                VStack(spacing: 8) {
                                    Text("\(count)")
                                        .font(Theme.captionStyle)
                                        .foregroundColor(Theme.textSecondary)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Theme.accentColor.opacity(0.8))
                                        .frame(width: 24, height: max(20, CGFloat(count) * 20))
                                    
                                    Text(day)
                                        .font(Theme.captionStyle)
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 120)
                }
                .padding(Theme.cardPadding)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                .padding(.horizontal, Theme.screenPadding)
                
                // Recent entries
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Entries")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textSecondary)
                    
                    if viewModel.entries.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 32))
                                .foregroundColor(Theme.textSecondary.opacity(0.5))
                            Text("No entries yet")
                                .font(Theme.bodyStyle)
                                .foregroundColor(Theme.textSecondary.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(viewModel.entries.prefix(5)) { entry in
                            RecentEntryRow(entry: entry)
                        }
                    }
                }
                .padding(Theme.cardPadding)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                .padding(.horizontal, Theme.screenPadding)
            }
            .padding(.vertical, Theme.screenPadding)
        }
        .background(Theme.backgroundColor)
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                isSignedIn = false
                isGuestUser = false
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Theme.accentColor)
                Text(title)
                    .font(Theme.captionStyle)
                    .foregroundColor(Theme.textSecondary)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Text(unit)
                    .font(Theme.captionStyle)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.cardPadding)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
}

struct RecentEntryRow: View {
    let entry: JournalEntry
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.title)
                .font(Theme.bodyStyle)
                .foregroundColor(Theme.textPrimary)
            
            Text(entry.content)
                .font(Theme.captionStyle)
                .foregroundColor(Theme.textSecondary)
                .lineLimit(2)
            
            Text(dateFormatter.string(from: entry.date))
                .font(Theme.captionStyle)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    InsightsView()
} 