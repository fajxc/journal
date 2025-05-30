import SwiftUI

struct InsightsView: View {
    // Mock data - replace with real data later
    private let currentStreak = 5
    private let totalEntries = 28
    private let weeklyActivity = [4, 3, 5, 4, 2, 3, 1]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("insights")
                    .font(Theme.headerStyle)
                    .foregroundColor(Theme.textPrimary)
                    .padding(.horizontal, Theme.screenPadding)
                
                // Stats cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "current streak",
                        value: "\(currentStreak)",
                        unit: "days",
                        icon: "flame.fill"
                    )
                    
                    StatCard(
                        title: "total entries",
                        value: "\(totalEntries)",
                        unit: "notes",
                        icon: "book.fill"
                    )
                }
                .padding(.horizontal, Theme.screenPadding)
                
                // Activity graph
                VStack(alignment: .leading, spacing: 12) {
                    Text("weekly activity")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textSecondary)
                    
                    HStack(alignment: .bottom, spacing: 12) {
                        ForEach(weeklyActivity.indices, id: \.self) { index in
                            VStack {
                                Text("\(weeklyActivity[index])")
                                    .font(Theme.captionStyle)
                                    .foregroundColor(Theme.textSecondary)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Theme.accentColor.opacity(0.8))
                                    .frame(width: 24, height: CGFloat(weeklyActivity[index]) * 20)
                                
                                Text(weekdayLetter(for: index))
                                    .font(Theme.captionStyle)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                    }
                }
                .padding(Theme.cardPadding)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                .padding(.horizontal, Theme.screenPadding)
                
                // Recent entries
                VStack(alignment: .leading, spacing: 16) {
                    Text("recent entries")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textSecondary)
                    
                    ForEach(0..<5) { index in
                        RecentEntryRow(
                            title: "Morning reflection",
                            preview: "Today I focused on gratitude and mindfulness...",
                            date: Date().addingTimeInterval(-Double(index * 86400))
                        )
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
    }
    
    private func weekdayLetter(for index: Int) -> String {
        let weekdays = ["M", "T", "W", "T", "F", "S", "S"]
        return weekdays[index]
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
    let title: String
    let preview: String
    let date: Date
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Theme.bodyStyle)
                .foregroundColor(Theme.textPrimary)
            
            Text(preview)
                .font(Theme.captionStyle)
                .foregroundColor(Theme.textSecondary)
                .lineLimit(1)
            
            Text(dateFormatter.string(from: date))
                .font(Theme.captionStyle)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    InsightsView()
} 