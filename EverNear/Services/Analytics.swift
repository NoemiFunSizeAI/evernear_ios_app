import Foundation

class Analytics {
    static let shared = Analytics()
    
    private init() {}
    
    func track(_ event: SubscriptionEvent) {
        switch event {
        case .viewed:
            logEvent("subscription_viewed")
        case .started(let tier):
            logEvent("subscription_started", properties: ["tier": tier.rawValue])
        case .completed(let tier):
            logEvent("subscription_completed", properties: ["tier": tier.rawValue])
        case .cancelled:
            logEvent("subscription_cancelled")
        case .restored:
            logEvent("subscription_restored")
        case .upgraded(let from, let to):
            logEvent("subscription_upgraded", properties: [
                "from_tier": from.rawValue,
                "to_tier": to.rawValue
            ])
        }
    }
    
    func trackGriefJourney(lovedOne: LovedOne, newStage: GriefStage) {
        logEvent("grief_stage_changed", properties: [
            "loved_one_id": lovedOne.id,
            "previous_stage": lovedOne.griefStage.rawValue,
            "new_stage": newStage.rawValue,
            "days_since_passing": Calendar.current.dateComponents([.day], from: lovedOne.dateOfPassing, to: Date()).day ?? 0
        ])
    }
    
    private func logEvent(_ name: String, properties: [String: Any] = [:]) {
        // TODO: Implement actual analytics service (e.g., Firebase, Mixpanel)
        print("Analytics Event: \\(name)")
        print("Properties: \\(properties)")
    }
}
