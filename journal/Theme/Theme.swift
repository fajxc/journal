import SwiftUI

enum Theme {
    static let backgroundColor = Color(red: 0.11, green: 0.11, blue: 0.12) // Dark gray with slight blue tint
    static let cardBackground = Color(red: 0.15, green: 0.15, blue: 0.16)  // Slightly lighter dark gray
    static let accentColor = Color(red: 0.4, green: 0.45, blue: 0.5)      // Muted blue
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.7)
    
    static let headerStyle: Font = .system(.title3, design: .default).weight(.medium)
    static let bodyStyle: Font = .system(.body, design: .default)
    static let captionStyle: Font = .system(.caption, design: .default)
    
    static func buttonStyle(isProminent: Bool = false) -> some View {
        Group {
            if isProminent {
                accentColor
            } else {
                cardBackground
            }
        }
    }
    
    static let cardPadding: CGFloat = 16
    static let screenPadding: CGFloat = 20
    static let cornerRadius: CGFloat = 12
} 