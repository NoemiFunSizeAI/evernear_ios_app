import SwiftUI

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var emotionManager = EmotionManager()
    @State private var selectedTab: Tab = .home
    @State private var showSearch = false
    @State private var lastNavigation = Date()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(Tab.home)
                    .contextTransition(depth: .deeper)
                
                MemoriesView()
                    .tag(Tab.memories)
                    .contextTransition(depth: .deeper)
                
                CompanionView()
                    .tag(Tab.companion)
                    .contextTransition(depth: .deeper)
                
                JournalView()
                    .tag(Tab.journal)
                    .contextTransition(depth: .deeper)
                
                ProfileView()
                    .tag(Tab.profile)
                    .contextTransition(depth: .deeper)
            }
            .overlay(alignment: .top) {
                NavigationHeader(showSearch: $showSearch)
                    .fadeScaleTransition()
            }
            
            NavigationBar(selectedTab: $selectedTab)
                .padding(.bottom, 8)
                .slideTransition(edge: .bottom)
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
                .environmentObject(navigationManager)
        }
        .onChange(of: selectedTab) { newTab in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                navigationManager.navigate(to: newTab.defaultContext)
                lastNavigation = Date()
            }
        }
        .onChange(of: navigationManager.currentContext) { newContext in
            if lastNavigation.timeIntervalSinceNow < -0.1 {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    // Update tab if context requires different tab
                    if let requiredTab = newContext.requiredTab,
                       requiredTab != selectedTab {
                        selectedTab = requiredTab
                    }
                }
            }
        }
        .environmentObject(navigationManager)
        .environmentObject(emotionManager)
    }
}

class NavigationManager: ObservableObject {
    @Published var currentContext: NavigationContext = .home
    @Published var breadcrumbs: [NavigationContext] = []
    @Published var recentContexts: [NavigationContext] = []
    private let maxRecentContexts = 10
    
    func navigate(to context: NavigationContext) {
        // Add current context to breadcrumbs
        breadcrumbs.append(currentContext)
        
        // Update current context
        currentContext = context
        
        // Add to recent contexts
        if !recentContexts.contains(context) {
            recentContexts.insert(context, at: 0)
            if recentContexts.count > maxRecentContexts {
                recentContexts.removeLast()
            }
        }
    }
    
    func goBack() {
        guard let previous = breadcrumbs.popLast() else { return }
        currentContext = previous
    }
    
    func clearHistory() {
        breadcrumbs.removeAll()
    }
    
    func navigateToRoot() {
        clearHistory()
        currentContext = .home
    }
    
    func canNavigateBack() -> Bool {
        !breadcrumbs.isEmpty
    }
}

class EmotionManager: ObservableObject {
    @Published var currentEmotion: EmotionState = .neutral
    @Published var emotionHistory: [EmotionEntry] = []
    
    func updateEmotion(_ emotion: EmotionState) {
        currentEmotion = emotion
        emotionHistory.append(EmotionEntry(emotion: emotion, timestamp: Date()))
    }
}

struct EmotionEntry: Identifiable {
    let id = UUID()
    let emotion: EmotionState
    let timestamp: Date
}

extension Tab {
    var defaultContext: NavigationContext {
        switch self {
        case .home: return .companion(mode: .chat)
        case .memories: return .memories(category: nil)
        case .companion: return .companion(mode: .chat)
        case .journal: return .journal(entry: nil)
        case .profile: return .supportNetwork
        }
    case profile(section: ProfileSection?)
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .memories(let category):
            return category?.name ?? "Memories"
        case .companion(let mode):
            return mode.title
        case .journal:
            return "Journal"
        case .profile(let section):
            return section?.title ?? "Profile"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .memories(let category):
            return category?.description
        case .companion(let mode):
            return mode.description
        case .journal(let entry):
            return entry?.date.formatted(date: .long, time: .none)
        case .profile(let section):
            return section?.description
        default:
            return nil
        }
    }
}

enum CompanionMode {
    case chat, voice, memory
    
    var title: String {
        switch self {
        case .chat: return "Chat"
        case .voice: return "Voice Chat"
        case .memory: return "Memory Review"
        }
    }
    
    var description: String {
        switch self {
        case .chat: return "Text-based conversation"
        case .voice: return "Voice-enabled interaction"
        case .memory: return "Review and reflect on memories"
        }
    }
}
