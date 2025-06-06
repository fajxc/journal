import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var journalViewModel: JournalViewModel
    @EnvironmentObject private var tabViewModel: MainTabViewModel
    @State private var showingNewEntry = false
    @State private var selectedDate = Date()
    @State private var reframeText = ""
    @State private var sleepQuality: Double = 0.5
    @State private var mood: Double = 0.5
    @State private var sleepQualitySet = false
    @State private var moodSet = false
    @State private var moodByDate: [String: Double] = [:] // date string -> mood
    
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let today = Date()
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    private var currentWeekDates: [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: today)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 2), to: today) ?? today // Monday as start
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.ignoresSafeArea()
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("be great.")
                        .font(Theme.headerStyle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 8)
                
                // Weekday Scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(zip(weekdays, currentWeekDates)), id: \.1) { (day, date) in
                            let isToday = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                            let dateKey = dateFormatter.string(from: date)
                            let moodValue = moodByDate[dateKey]
                            let bubbleColor: Color = {
                                if let moodValue = moodValue {
                                    if moodValue > 0.6 { return .green.opacity(0.4) }
                                    if moodValue < 0.4 { return .red.opacity(0.4) }
                                }
                                return isToday ? Color(hex: "2C2C2E") : Theme.cardBackground
                            }()
                            VStack(spacing: 4) {
                                Text(day)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(width: isToday ? 58 : 48, height: isToday ? 54 : 46)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(bubbleColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(isToday ? Color.white.opacity(0.7) : Color.clear, lineWidth: isToday ? 2 : 0)
                            )
                            .shadow(color: isToday ? Color.white.opacity(0.08) : .clear, radius: 4, x: 0, y: 2)
                            .onTapGesture { selectedDate = date }
                        }
                    }
                    .padding(.horizontal, Theme.screenPadding)
                }
                .padding(.vertical, 8)
                
                // Reframe Input + Button
                HStack(spacing: 12) {
                    TextField("reframe", text: $reframeText)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(Theme.cardBackground)
                        .foregroundColor(.white)
                        .cornerRadius(Theme.cornerRadius)
                        .font(Theme.bodyStyle)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .stroke(Color.clear, lineWidth: 0)
                        )
                    Button(action: { /* reframe action */ }) {
                        Text("reframe")
                            .font(Theme.bodyStyle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(Color(hex: "2C2C2E"))
                            .cornerRadius(Theme.cornerRadius)
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                
                // Today Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today")
                        .font(Theme.headerStyle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 2)
                    HStack(spacing: 16) {
                        TodayBox(title: "Seneca", subtitle: "Ask me anything", imageName: "person.crop.circle", action: { tabViewModel.selectedTab = .journal })
                        TodayBox(title: "Marcus Aurelius", subtitle: "Quote of the day", imageName: "person.crop.circle.fill", action: { tabViewModel.selectedTab = .pause })
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                
                // Sleep Quality & Mood Sliders
                VStack(alignment: .leading, spacing: 20) {
                    Text("today's stats")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    HStack {
                        Text("Sleep")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(Int(sleepQuality * 100))%")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                    }
                    Slider(value: $sleepQuality, in: 0...1, step: 0.01, onEditingChanged: { editing in
                        if !editing { sleepQualitySet = true }
                    })
                    .disabled(sleepQualitySet)
                    .accentColor(.white)
                    .opacity(sleepQualitySet ? 0.5 : 1.0)
                    .frame(height: 8)
                    .background(Theme.cardBackground)
                    .cornerRadius(4)

                    Text("Mood")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    HStack {
                        Text("Mood")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(Int(mood * 100))%")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                    }
                    Slider(value: $mood, in: 0...1, step: 0.01, onEditingChanged: { editing in
                        if !editing {
                            moodSet = true
                            let dateKey = dateFormatter.string(from: selectedDate)
                            moodByDate[dateKey] = mood
                        }
                    })
                    .disabled(moodSet)
                    .accentColor(.white)
                    .opacity(moodSet ? 0.5 : 1.0)
                    .frame(height: 8)
                    .background(Theme.cardBackground)
                    .cornerRadius(4)
                }
                .padding(.horizontal, Theme.screenPadding)
                
                // Inspiration Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Inspiration")
                        .font(Theme.headerStyle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("The power of now")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            Text("by Eckhart Tolle")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        Rectangle()
                            .fill(Theme.cardBackground)
                            .frame(width: 48, height: 64)
                            .overlay(
                                Text("cover")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            )
                            .cornerRadius(8)
                    }
                    .padding(12)
                    .background(Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadius)
                }
                .padding(.horizontal, Theme.screenPadding)
                Spacer(minLength: 24)
            }
            .padding(.top, 8)
        }
    }
}

struct TodayBox: View {
    let title: String
    let subtitle: String
    let imageName: String
    let fixedHeight: CGFloat = 92 // matches the taller box in the screenshot
    var action: (() -> Void)? = nil
    var body: some View {
        Button(action: { action?() }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(subtitle)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxHeight: 40, alignment: .top)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
                Rectangle()
                    .fill(Theme.cardBackground)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white.opacity(0.7))
                            .padding(8)
                    )
                    .cornerRadius(8)
            }
            .padding(12)
            .frame(height: fixedHeight)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProgressSection: View {
    let title: String
    let leftLabel: String
    let rightLabel: String
    let progress: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            HStack {
                Text(leftLabel)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text(rightLabel)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
            }
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .frame(height: 8)
                .background(Theme.cardBackground)
                .cornerRadius(4)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(JournalViewModel())
        .environmentObject(MainTabViewModel())
} 