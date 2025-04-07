import Foundation
import StoreKit

enum SubscriptionTier: String, CaseIterable {
    case free = "Free"
    case basic = "Basic"
    case premium = "Premium"
    
    var features: [String] {
        switch self {
        case .free:
            return [
                "Store up to 50 memories",
                "Basic AI companion interactions",
                "Simple journal entries",
                "Community support access"
            ]
        case .basic:
            return [
                "Store up to 500 memories",
                "Enhanced AI companion features",
                "Advanced journaling tools",
                "Voice memory recording",
                "Mood tracking",
                "Support group access"
            ]
        case .premium:
            return [
                "Unlimited memories",
                "Priority AI companion access",
                "Advanced emotional analysis",
                "Video memories",
                "Family sharing (up to 5 members)",
                "Professional counselor matching",
                "Custom memory categories",
                "Premium support"
            ]
        }
    }
    
    var monthlyPrice: Decimal {
        switch self {
        case .free: return 0
        case .basic: return 4.99
        case .premium: return 9.99
        }
    }
    
    var yearlyPrice: Decimal {
        switch self {
        case .free: return 0
        case .basic: return 49.99  // ~17% discount
        case .premium: return 99.99 // ~17% discount
        }
    }
}

class SubscriptionManager: ObservableObject {
    @Published private(set) var currentTier: SubscriptionTier = .free
    @Published private(set) var isLifetimePurchased = false
    
    static let shared = SubscriptionManager()
    
    private init() {
        // Load subscription status from UserDefaults or your backend
        loadSubscriptionStatus()
    }
    
    private func loadSubscriptionStatus() {
        // TODO: Implement proper subscription validation with App Store
        if let savedTier = UserDefaults.standard.string(forKey: "subscriptionTier"),
           let tier = SubscriptionTier(rawValue: savedTier) {
            currentTier = tier
        }
        isLifetimePurchased = UserDefaults.standard.bool(forKey: "isLifetimePurchased")
    }
    
    func purchase(_ tier: SubscriptionTier, interval: SubscriptionInterval) async throws {
        // TODO: Implement StoreKit purchase flow
        // This is a placeholder for the actual implementation
    }
    
    func restorePurchases() async throws {
        // TODO: Implement StoreKit restore purchases
    }
}

enum SubscriptionInterval {
    case monthly
    case yearly
    
    var discount: Double {
        switch self {
        case .monthly: return 0
        case .yearly: return 0.17 // 17% discount
        }
    }
}
