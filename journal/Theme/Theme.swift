import SwiftUI

enum Theme {
    // Colors
    static let backgroundColor = Color.black
    static let cardBackground = Color(hex: "1C1C1E")
    static let accentColor = Color(hex: "3A3A3C")
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    
    // Typography
    static let headerStyle = Font.system(size: 32, weight: .bold)
    static let bodyStyle = Font.system(size: 16, weight: .regular)
    static let captionStyle = Font.system(size: 14, weight: .regular)
    
    // Layout
    static let cornerRadius: CGFloat = 12
    static let screenPadding: CGFloat = 16
    static let cardPadding: CGFloat = 16
    
    // Button Styles
    static func buttonStyle(isProminent: Bool = false) -> Color {
        isProminent ? accentColor : cardBackground
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 