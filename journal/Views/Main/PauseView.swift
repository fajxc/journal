import SwiftUI

struct PauseView: View {
    @State private var selectedMode: TimerMode = .meditation
    @State private var timeRemaining: TimeInterval = 0
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    
    enum TimerMode {
        case meditation, pomodoro
        
        var title: String {
            switch self {
            case .meditation: return "meditation"
            case .pomodoro: return "pomodoro"
            }
        }
        
        var defaultDuration: TimeInterval {
            switch self {
            case .meditation: return 600 // 10 minutes
            case .pomodoro: return 1500 // 25 minutes
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("pause")
                .font(Theme.headerStyle)
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, Theme.screenPadding)
            
            // Mode selector
            HStack(spacing: 16) {
                ForEach([TimerMode.meditation, .pomodoro], id: \.self) { mode in
                    Button(action: { selectMode(mode) }) {
                        Text(mode.title)
                            .font(Theme.bodyStyle)
                            .foregroundColor(selectedMode == mode ? Theme.textPrimary : Theme.textSecondary)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(selectedMode == mode ? Theme.cardBackground : Color.clear)
                            .cornerRadius(Theme.cornerRadius)
                    }
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            
            // Timer display
            VStack(spacing: 40) {
                Text(timeString(from: timeRemaining))
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(Theme.textPrimary)
                    .monospacedDigit()
                
                // Control buttons
                HStack(spacing: 40) {
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Button(action: toggleTimer) {
                        Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(Theme.textPrimary)
                            .frame(width: 64, height: 64)
                            .background(Theme.cardBackground)
                            .clipShape(Circle())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 60)
            
            // Quick duration buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([5, 10, 15, 20, 25, 30], id: \.self) { minutes in
                        Button(action: { setDuration(minutes: minutes) }) {
                            Text("\(minutes)m")
                                .font(Theme.bodyStyle)
                                .foregroundColor(Theme.textSecondary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Theme.cardBackground)
                                .cornerRadius(Theme.cornerRadius)
                        }
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
            }
            
            Spacer()
        }
        .padding(.top, Theme.screenPadding)
        .background(Theme.backgroundColor)
        .onAppear {
            resetTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func selectMode(_ mode: TimerMode) {
        selectedMode = mode
        resetTimer()
    }
    
    private func toggleTimer() {
        if isTimerRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.invalidate()
                    timer = nil
                    isTimerRunning = false
                }
            }
        }
        isTimerRunning.toggle()
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        timeRemaining = selectedMode.defaultDuration
    }
    
    private func setDuration(minutes: Int) {
        timeRemaining = TimeInterval(minutes * 60)
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    PauseView()
} 