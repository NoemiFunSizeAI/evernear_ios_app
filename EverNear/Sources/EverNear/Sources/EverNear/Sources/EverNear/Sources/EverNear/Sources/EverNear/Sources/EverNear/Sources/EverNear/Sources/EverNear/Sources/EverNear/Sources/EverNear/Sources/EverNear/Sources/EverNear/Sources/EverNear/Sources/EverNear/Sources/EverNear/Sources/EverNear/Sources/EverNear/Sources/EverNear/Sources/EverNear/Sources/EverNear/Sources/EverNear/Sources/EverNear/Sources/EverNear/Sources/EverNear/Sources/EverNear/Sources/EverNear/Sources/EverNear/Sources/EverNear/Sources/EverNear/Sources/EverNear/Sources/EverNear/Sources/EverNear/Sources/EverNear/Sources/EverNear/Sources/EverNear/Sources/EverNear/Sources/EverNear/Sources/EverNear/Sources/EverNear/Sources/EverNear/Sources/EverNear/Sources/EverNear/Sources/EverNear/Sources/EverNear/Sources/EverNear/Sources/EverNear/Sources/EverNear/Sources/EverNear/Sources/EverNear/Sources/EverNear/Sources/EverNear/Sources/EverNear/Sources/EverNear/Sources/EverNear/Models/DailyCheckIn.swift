import Foundation

struct DailyCheckIn {
    let date: Date
    let emotionalState: EmotionalState
    let activities: [String]
    let selfCareActions: [String]
    let notes: String?
    let supportNeeded: Bool
}

class CheckInManager {
    static let shared = CheckInManager()
    private var checkIns: [DailyCheckIn] = []
    
    // Get check-in prompts based on time and previous responses
    func getCheckInPrompt() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        // Morning check-in (6 AM - 11 AM)
        if (6...11).contains(hour) {
            return "Good morning. How are you feeling as you start your day? Remember, there's no right or wrong way to feel."
        }
        
        // Afternoon check-in (12 PM - 5 PM)
        if (12...17).contains(hour) {
            return "Taking a moment to check in - how is your heart feeling right now? What emotions are present for you?"
        }
        
        // Evening check-in (6 PM - 10 PM)
        if (18...22).contains(hour) {
            return "As the day winds down, how are you holding up? Would you like to share any moments from today?"
        }
        
        // Late night check-in (11 PM - 5 AM)
        return "I notice you're up late. Nights can be especially hard when grieving. How are you feeling right now?"
    }
    
    // Suggest self-care activities based on emotional state
    func getSelfCareRecommendation(forEmotion emotion: String) -> String {
        let activities: [String: [String]] = [
            "deep_grief": [
                "Take slow, deep breaths - I'm here with you",
                "Would you like to try a gentle grounding exercise?",
                "Consider wrapping yourself in a cozy blanket",
                "Maybe put on some calming music?"
            ],
            "raw_pain": [
                "It's okay to take a break and rest",
                "Consider reaching out to someone you trust",
                "Would some gentle movement help?",
                "Remember to stay hydrated"
            ],
            "anger": [
                "Find a safe way to release this energy",
                "Maybe write down your feelings",
                "Take a walk if you feel up to it",
                "It's okay to cry or shout if you need to"
            ],
            "anxiety": [
                "Let's try some simple breathing together",
                "Can you name 5 things you can see right now?",
                "Would holding something soft help?",
                "Consider some gentle stretching"
            ],
            "numbness": [
                "Try holding an ice cube or smelling something strong",
                "Splash some cold water on your face",
                "Take a short walk, even just around the room",
                "Put on music that usually moves you"
            ],
            "hope": [
                "Consider journaling this moment",
                "Maybe look at some photos",
                "Share this feeling with someone who cares",
                "Do something that honors their memory"
            ]
        ]
        
        return activities[emotion]?.randomElement() ?? "Would you like to try a gentle self-care activity?"
    }
    
    // Record a daily check-in
    func recordCheckIn(_ checkIn: DailyCheckIn) {
        checkIns.append(checkIn)
    }
    
    // Get check-in history for the past week
    func getWeeklyCheckIns() -> [DailyCheckIn] {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        return checkIns
            .filter { $0.date >= oneWeekAgo }
            .sorted { $0.date > $1.date }
    }
    
    // Analyze emotional patterns
    func analyzeEmotionalPattern() -> String {
        let weeklyCheckIns = getWeeklyCheckIns()
        guard !weeklyCheckIns.isEmpty else { return "" }
        
        var emotionCounts: [String: Int] = [:]
        var totalIntensity = 0
        
        for checkIn in weeklyCheckIns {
            emotionCounts[checkIn.emotionalState.primaryEmotion, default: 0] += 1
            totalIntensity += checkIn.emotionalState.intensity
        }
        
        let averageIntensity = Double(totalIntensity) / Double(weeklyCheckIns.count)
        let predominantEmotion = emotionCounts.max(by: { $0.value < $1.value })?.key
        
        if averageIntensity > 7 {
            return "I've noticed your emotions have been particularly intense this week. Would you like to talk about what's been happening?"
        } else if let emotion = predominantEmotion {
            return "I notice \(emotion) has been coming up a lot lately. How are you making sense of these feelings?"
        }
        
        return "Thank you for continuing to check in. How can I support you today?"
    }
}
