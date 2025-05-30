import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingCreateModal = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                JournalView()
                    .tabItem {
                        Label("journal", systemImage: "book.fill")
                    }
                    .tag(1)
                
                Color.clear
                    .tabItem {
                        Label("create", systemImage: "plus.circle.fill")
                    }
                    .tag(2)
                
                PauseView()
                    .tabItem {
                        Label("pause", systemImage: "leaf.fill")
                    }
                    .tag(3)
                
                InsightsView()
                    .tabItem {
                        Label("insights", systemImage: "chart.bar.fill")
                    }
                    .tag(4)
            }
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 2 {
                    showingCreateModal = true
                    selectedTab = 0 // Reset to home tab
                }
            }
            
            if showingCreateModal {
                CreateModal(isPresented: $showingCreateModal)
                    .transition(.move(edge: .bottom))
            }
        }
        .background(Theme.backgroundColor)
    }
}

struct CreateModal: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Theme.cardBackground)
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            Text("create")
                .font(Theme.headerStyle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ScrollView {
                VStack(spacing: 16) {
                    CreateOptionButton(
                        title: "new blank journal entry",
                        icon: "square.and.pencil",
                        action: {
                            // TODO: Handle new entry
                            isPresented = false
                        }
                    )
                    
                    CreateOptionButton(
                        title: "reflect on today",
                        icon: "sun.max",
                        action: {
                            // TODO: Handle reflection
                            isPresented = false
                        }
                    )
                    
                    CreateOptionButton(
                        title: "voice note",
                        icon: "waveform",
                        action: {
                            // TODO: Handle voice note
                            isPresented = false
                        }
                    )
                }
                .padding()
            }
        }
        .background(
            Theme.backgroundColor
                .overlay(
                    Theme.cardBackground.opacity(0.8)
                )
                .ignoresSafeArea()
        )
        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
        .transition(.move(edge: .bottom))
    }
}

struct CreateOptionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Theme.textPrimary)
                    .frame(width: 32)
                
                Text(title)
                    .font(Theme.bodyStyle)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
        }
    }
}

#Preview {
    MainTabView()
} 