import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var thoughtText = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("be great.")
                    .font(Theme.headerStyle)
                    .foregroundColor(Theme.textPrimary)
                    .padding(.horizontal, Theme.screenPadding)
                    .padding(.top, Theme.screenPadding)
                
                // Day selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(-3...3, id: \.self) { offset in
                            let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
                            DayButton(
                                date: date,
                                isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                dateFormatter: dateFormatter,
                                weekdayFormatter: weekdayFormatter
                            ) {
                                selectedDate = date
                            }
                        }
                    }
                    .padding(.horizontal, Theme.screenPadding)
                }
                
                // Thought input
                VStack(alignment: .leading, spacing: 10) {
                    Text("what's on your mind?")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textPrimary)
                    
                    TextField("type here...", text: $thoughtText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.horizontal, Theme.screenPadding)
                
                // Quote cards
                HStack(spacing: 15) {
                    // Seneca Quote Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("seneca says")
                            .font(Theme.captionStyle)
                            .foregroundColor(Theme.textSecondary)
                        
                        Text("The greatest blessings of mankind are within us and within our reach.")
                            .font(Theme.bodyStyle)
                            .foregroundColor(Theme.textPrimary)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Theme.cardPadding)
                    .background(Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadius)
                    
                    // Marcus Aurelius Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("marcus aurelius")
                            .font(Theme.captionStyle)
                            .foregroundColor(Theme.textSecondary)
                        
                        Spacer()
                        
                        Button(action: {
                            // TODO: Navigate to chat
                        }) {
                            Text("ask me anything")
                                .font(Theme.bodyStyle)
                                .foregroundColor(Theme.accentColor)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Theme.cardPadding)
                    .background(Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadius)
                }
                .frame(height: 150)
                .padding(.horizontal, Theme.screenPadding)
                
                // Journal prompt
                VStack(alignment: .leading, spacing: 10) {
                    Text("today's reflection")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("what past experience are you most grateful for?")
                        .font(Theme.captionStyle)
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(Theme.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                .padding(.horizontal, Theme.screenPadding)
            }
            .padding(.vertical)
        }
        .background(Theme.backgroundColor)
    }
}

struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let dateFormatter: DateFormatter
    let weekdayFormatter: DateFormatter
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(weekdayFormatter.string(from: date).lowercased())
                    .font(Theme.captionStyle)
                    .foregroundColor(isSelected ? Theme.textPrimary : Theme.textSecondary)
                
                Text(dateFormatter.string(from: date))
                    .font(Theme.bodyStyle)
                    .foregroundColor(isSelected ? Theme.textPrimary : Theme.textSecondary)
            }
            .frame(width: 45, height: 70)
            .background(isSelected ? Theme.accentColor : Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
        }
    }
}

#Preview {
    HomeView()
} 