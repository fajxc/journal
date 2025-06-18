import SwiftUI

struct HomeCard: View {
    let title: String
    let subtitle: String
    let icon: String // Unused now, but kept for compatibility
    let action: () -> Void
    
    private let cardHeight: CGFloat = 76 // Set a fixed height for all cards

    var body: some View {
        Button(action: action) {
            if subtitle.isEmpty {
                // Centered, normal size, bold, white text for 'Quote of the day', fixed height
                HStack {
                    Spacer()
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .layoutPriority(1)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: cardHeight)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
                )
            } else {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .layoutPriority(1)
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .layoutPriority(1)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: cardHeight)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
                )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
    }
} 