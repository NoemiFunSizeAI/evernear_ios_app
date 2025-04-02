import Foundation

struct EmotionalState {
    var primaryEmotion: String
    var intensity: Int
    var mixedEmotions: [String]
    var timestamp: Date
}

class EmotionalAnalyzer {
    // More natural emotional keywords that people commonly use
    private let emotionalPatterns: [String: [String]] = [
        "sadness": [
            "miss", "hurts", "crying", "tears", "heartbroken", "down",
            "rough", "hard", "heavy", "blue", "awful"
        ],
        "anger": [
            "angry", "mad", "unfair", "hate", "frustrated", "upset",
            "pissed", "fed up", "sick of"
        ],
        "guilt": [
            "should have", "wish i", "if only", "my fault", "regret",
            "blame", "sorry"
        ],
        "anxiety": [
            "worried", "scared", "nervous", "panic", "stress",
            "cant sleep", "restless", "on edge"
        ],
        "numbness": [
            "numb", "empty", "nothing", "blank", "cant feel",
            "going through motions", "robot"
        ],
        "hope": [
            "better", "okay", "managing", "trying", "good day",
            "smile", "laugh", "remember"
        ]
    ]
    
    // Words that indicate intensity
    private let intensityModifiers: [String: Int] = [
        "really": 2,
        "so": 2,
        "very": 2,
        "extremely": 3,
        "completely": 3,
        "totally": 3,
        "cant even": 3,
        "at all": 2,
        "always": 2,
        "never": 2
    ]
    
    func analyzeEmotion(_ text: String) -> EmotionalState {
        let words = text.lowercased().split(separator: " ").map(String.init)
        var emotionScores: [String: Int] = [:]
        var detectedEmotions: Set<String> = []
        var totalIntensity = 0
        var intensityCount = 0
        
        // Analyze emotion patterns
        for (emotion, patterns) in emotionalPatterns {
            var score = 0
            for pattern in patterns {
                if text.lowercased().contains(pattern) {
                    score += 1
                    detectedEmotions.insert(emotion)
                }
            }
            if score > 0 {
                emotionScores[emotion] = score
            }
        }
        
        // Analyze intensity
        for (modifier, value) in intensityModifiers {
            if text.lowercased().contains(modifier) {
                totalIntensity += value
                intensityCount += 1
            }
        }
        
        // Calculate final intensity (1-10 scale)
        let baseIntensity = intensityCount > 0 ? totalIntensity / intensityCount : 1
        let finalIntensity = min(max(baseIntensity * 2, 1), 10)
        
        // Determine primary emotion
        let primaryEmotion = emotionScores.max(by: { $0.value < $1.value })?.key ?? "mixed"
        
        // Get mixed emotions (excluding primary)
        var mixedEmotions = Array(detectedEmotions)
        if let primaryIndex = mixedEmotions.firstIndex(of: primaryEmotion) {
            mixedEmotions.remove(at: primaryIndex)
        }
        
        return EmotionalState(
            primaryEmotion: primaryEmotion,
            intensity: finalIntensity,
            mixedEmotions: mixedEmotions,
            timestamp: Date()
        )
    }
    
    func generateResponse(to state: EmotionalState) -> String {
        // Base responses that sound more natural and conversational
        let responses: [String: [String]] = [
            "sadness": [
                "Yeah, this is really tough. Want to tell me more?",
                "That sounds so hard. I'm right here with you.",
                "It's okay to not be okay. What's on your mind?"
            ],
            "anger": [
                "I get why you're angry. This whole thing is unfair.",
                "You have every right to feel this way.",
                "I'd be mad too. Let it out if you need to."
            ],
            "guilt": [
                "Hey, try not to be so hard on yourself.",
                "We all have those 'what if' thoughts. It's normal.",
                "You did the best you could with what you knew then."
            ],
            "anxiety": [
                "One step at a time, okay? What's worrying you the most?",
                "That sounds really overwhelming. Need to talk it through?",
                "Sometimes just naming what's making us anxious helps a bit."
            ],
            "numbness": [
                "Sometimes not feeling anything is the body's way of coping.",
                "That numbness you're feeling? Totally normal after what you've been through.",
                "It won't always feel this empty. Promise."
            ],
            "hope": [
                "It's good to hear you had a better moment.",
                "Those little glimpses of okay are important.",
                "Yeah, hold onto those good memories."
            ],
            "mixed": [
                "Sounds like you're feeling a lot of different things. That's normal.",
                "Grief isn't just one feeling, is it?",
                "There's no right or wrong way to feel about this."
            ]
        ]
        
        // Get base response
        guard let baseResponses = responses[state.primaryEmotion],
              let response = baseResponses.randomElement() else {
            return "I hear you. Tell me more?"
        }
        
        // Add intensity-based follow-up if intensity is high
        if state.intensity >= 8 {
            return response + " Do you need someone to talk to right now? I can help you find support."
        }
        
        // Add mixed emotion acknowledgment if present
        if !state.mixedEmotions.isEmpty {
            return response + " It's okay to feel \(state.primaryEmotion) and \(state.mixedEmotions[0]) at the same time."
        }
        
        return response
    }
}
