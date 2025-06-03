import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MainTabViewModel()
    @StateObject private var journalViewModel = JournalViewModel()
    @State private var showingNewEntry = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                HomeView()
                    .environmentObject(journalViewModel)
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("home", systemImage: "house.fill")
                    }
                    .tag(MainTabViewModel.Tab.home)
                
                ChatView()
                    .tabItem {
                        Label("chat", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                    .tag(MainTabViewModel.Tab.journal)
                
                Color.clear
                    .tabItem { Label("create", systemImage: "plus") }
                    .tag(MainTabViewModel.Tab.create)
                
                PauseView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("pause", systemImage: "leaf.fill")
                    }
                    .tag(MainTabViewModel.Tab.pause)
                
                InsightsView()
                    .environmentObject(journalViewModel)
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("insights", systemImage: "chart.bar.fill")
                    }
                    .tag(MainTabViewModel.Tab.insights)
            }
            .tint(Theme.accentColor)
            .preferredColorScheme(.dark)
            .onChange(of: viewModel.selectedTab) { newTab in
                if newTab == .create {
                    showingNewEntry = true
                    // Reset tab selection to previous tab
                    viewModel.selectedTab = viewModel.previousTab
                }
            }
            
            if showingNewEntry {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingNewEntry = false
                    }
                
                ReflectionTopicView(isPresented: $showingNewEntry)
                    .environmentObject(journalViewModel)
                    .environmentObject(viewModel)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: showingNewEntry)
    }
}

#Preview {
    MainTabView()
} 