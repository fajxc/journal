import SwiftUI

struct IdeologySelectionView: View {
    @Binding var selectedIdeologies: Set<String>
    
    let ideologies = [
        "stoicism",
        "mindfulness",
        "minimalism",
        "existentialism",
        "buddhism",
        "secular humanism"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("what philosophies interest you?")
                .font(Theme.headerStyle)
                .foregroundColor(Theme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("select all that apply")
                .font(Theme.bodyStyle)
                .foregroundColor(Theme.textSecondary)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(ideologies, id: \.self) { ideology in
                        IdeologyButton(
                            title: ideology,
                            isSelected: selectedIdeologies.contains(ideology),
                            action: {
                                if selectedIdeologies.contains(ideology) {
                                    selectedIdeologies.remove(ideology)
                                } else {
                                    selectedIdeologies.insert(ideology)
                                }
                            }
                        )
                    }
                }
            }
        }
    }
}

struct IdeologyButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(Theme.bodyStyle)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(Theme.accentColor)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Theme.cardBackground.opacity(0.8) : Theme.cardBackground.opacity(0.4))
            .cornerRadius(Theme.cornerRadius)
        }
    }
}

#Preview {
    IdeologySelectionView(selectedIdeologies: .constant(["stoicism"]))
        .background(Theme.backgroundColor)
        .preferredColorScheme(.dark)
} 