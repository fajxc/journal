import SwiftUI
import Combine

class MainTabViewModel: ObservableObject {
    enum Tab {
        case home
        case journal
        case create
        case pause
        case insights
    }
    
    @Published var selectedTab: Tab = .home
    @Published var previousTab: Tab = .home
    
    init() {
        // Observe changes to selectedTab
        $selectedTab
            .sink { [weak self] newTab in
                if newTab != .create {
                    self?.previousTab = newTab
                }
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
} 