import Foundation
import Combine

class UsageTracker: ObservableObject {
    static let shared = UsageTracker()
    private let subscriptionManager = SubscriptionManager.shared
    
    @Published private(set) var memoryCount: Int = 0
    @Published private(set) var activeLovedOnes: Int = 0
    @Published private(set) var aiInteractionsThisMonth: Int = 0
    @Published private(set) var videoMemoriesCount: Int = 0
    @Published private(set) var supportGroupAccess: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadUsageData()
        setupSubscriptionObserver()
    }
    
    private func setupSubscriptionObserver() {
        subscriptionManager.$currentTier
            .sink { [weak self] tier in
                self?.updateFeatureLimits(for: tier)
            }
            .store(in: &cancellables)
    }
    
    private func updateFeatureLimits(for tier: SubscriptionTier) {
        switch tier {
        case .free:
            supportGroupAccess = false
        case .basic:
            supportGroupAccess = true
        case .premium:
            supportGroupAccess = true
        }
    }
    
    func canAddMemory() -> Bool {
        switch subscriptionManager.currentTier {
        case .free: return memoryCount < 50
        case .basic: return memoryCount < 500
        case .premium: return true
        }
    }
    
    func canAddLovedOne() -> Bool {
        switch subscriptionManager.currentTier {
        case .free: return activeLovedOnes < 1
        case .basic: return activeLovedOnes < 3
        case .premium: return activeLovedOnes < 10
        }
    }
    
    func canUseAI() -> Bool {
        switch subscriptionManager.currentTier {
        case .free: return aiInteractionsThisMonth < 20
        case .basic: return aiInteractionsThisMonth < 100
        case .premium: return true
        }
    }
    
    func canAddVideoMemory() -> Bool {
        return subscriptionManager.currentTier == .premium
    }
    
    // MARK: - Usage Tracking Methods
    
    func trackMemoryAdded() {
        memoryCount += 1
        saveUsageData()
    }
    
    func trackLovedOneAdded() {
        activeLovedOnes += 1
        saveUsageData()
    }
    
    func trackAIInteraction() {
        aiInteractionsThisMonth += 1
        saveUsageData()
    }
    
    func trackVideoMemoryAdded() {
        videoMemoriesCount += 1
        saveUsageData()
    }
    
    // MARK: - Persistence
    
    private func loadUsageData() {
        let defaults = UserDefaults.standard
        memoryCount = defaults.integer(forKey: "memoryCount")
        activeLovedOnes = defaults.integer(forKey: "activeLovedOnes")
        aiInteractionsThisMonth = defaults.integer(forKey: "aiInteractionsThisMonth")
        videoMemoriesCount = defaults.integer(forKey: "videoMemoriesCount")
        supportGroupAccess = defaults.bool(forKey: "supportGroupAccess")
    }
    
    private func saveUsageData() {
        let defaults = UserDefaults.standard
        defaults.set(memoryCount, forKey: "memoryCount")
        defaults.set(activeLovedOnes, forKey: "activeLovedOnes")
        defaults.set(aiInteractionsThisMonth, forKey: "aiInteractionsThisMonth")
        defaults.set(videoMemoriesCount, forKey: "videoMemoriesCount")
        defaults.set(supportGroupAccess, forKey: "supportGroupAccess")
    }
    
    // MARK: - Analytics
    
    func trackSubscriptionEvent(_ event: SubscriptionEvent) {
        Analytics.shared.track(event)
    }
}

enum SubscriptionEvent {
    case viewed
    case started(tier: SubscriptionTier)
    case completed(tier: SubscriptionTier)
    case cancelled
    case restored
    case upgraded(from: SubscriptionTier, to: SubscriptionTier)
}
