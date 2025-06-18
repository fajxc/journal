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
            Color.black.ignoresSafeArea()
            VStack(spacing: 32) {
                // Header
                HStack {
                    Text("be great.")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)
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
                                return isToday ? Color.white.opacity(0.12) : Color.white.opacity(0.06)
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
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 8)
                // Reframe Input + Button
                HStack(spacing: 12) {
                    TextField("reframe", text: $reframeText)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.08))
                        .foregroundColor(.white)
                        .cornerRadius(22)
                        .font(.system(size: 18))
                        .disableAutocorrection(true)
                        .submitLabel(.done)
                        .textInputAutocapitalization(.sentences)
                    Button(action: { /* reframe action */ }) {
                        Text("reframe")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 28)
                            .background(Color.white)
                            .cornerRadius(22)
                    }
                }
                .padding(.horizontal, 24)
                // Today Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Today")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    HStack(spacing: 16) {
                        HomeCard(title: "Seneca", subtitle: "Ask me anything", icon: "person.crop.circle") {
                            tabViewModel.selectedTab = .journal
                        }
                        HomeCard(title: "Quote of the day", subtitle: "", icon: "quote.bubble") {
                            tabViewModel.selectedTab = .pause
                        }
                    }
                }
                .padding(.horizontal, 24)
                // Sleep Quality & Mood Sliders
                VStack(alignment: .leading, spacing: 20) {
                    Text("today's stats")
                        .font(.system(size: 18, weight: .semibold))
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
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(4)
                    Text("Mood")
                        .font(.system(size: 18, weight: .semibold))
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
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(4)
                }
                .padding(.horizontal, 24)
                // Inspiration Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Inspiration")
                        .font(.system(size: 24, weight: .bold))
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
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 48, height: 64)
                            .overlay(
                                Text("cover")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            )
                            .cornerRadius(8)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.04))
                    .cornerRadius(16)
                }
                .padding(.horizontal, 24)
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
    let fixedHeight: CGFloat = 92
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
                    Text(subtitle)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
                Rectangle()
                    .fill(Color.white.opacity(0.08))
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
            .padding(16)
            .frame(height: fixedHeight)
            .background(Color.white.opacity(0.04))
            .cornerRadius(16)
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