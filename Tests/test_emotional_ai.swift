import Foundation

// Emotional state structure
struct EmotionalState {
    var primaryEmotion: String
    var intensity: Int
    var mixedEmotions: [String]
    var timestamp: Date
}

// Emotional analyzer
class EmotionalAnalyzer {
    // More natural emotional keywords that people commonly use
    // Phrases that indicate emotional intensity
    private let intensityPhrases: [String: Int] = [
        "cant even breathe": 4,
        "cant stop": 3,
        "completely": 3,
        "so much": 3,
        "really": 2,
        "very": 2,
        "just": -1,  // Reduces intensity
        "a bit": -1,  // Reduces intensity
        "sometimes": -1  // Reduces intensity
    ]
    
    private let emotionalPatterns: [String: [String]] = [
        "deep_grief": [
            "miss", "gone forever", "never again", "cant believe", "lost",
            "without you", "alone now", "empty inside", "heart hurts"
        ],
        "raw_pain": [
            "hurts", "pain", "ache", "crying", "tears", "heartbroken",
            "cant breathe", "physically hurts", "chest tight"
        ],
        "anger": [
            "angry", "mad", "unfair", "hate", "frustrated", "upset",
            "why did this happen", "shouldnt be this way", "taken away"
        ],
        "guilt": [
            "should have", "wish i", "if only", "my fault", "regret",
            "blame", "sorry", "didnt get to", "never told", "last chance"
        ],
        "anxiety": [
            "worried", "scared", "nervous", "panic", "stress",
            "cant sleep", "restless", "future", "how will i", "what if"
        ],
        "numbness": [
            "numb", "empty", "nothing", "blank", "cant feel",
            "going through motions", "robot", "disconnected", "surreal"
        ],
        "longing": [
            "wish", "remember when", "used to", "memories", "think about",
            "miss your", "want to hear", "one more time", "never again"
        ],
        "acceptance": [
            "trying", "learning", "day by day", "small steps", "somehow",
            "getting through", "surviving", "one day", "little better"
        ],
        "love": [
            "love", "loved", "special", "precious", "grateful", "thankful",
            "blessed", "lucky to have", "treasure", "cherish"
        ],
        "hope": [
            "better", "okay", "managing", "good moment", "smiled",
            "peaceful", "comfort", "warm", "light", "strength"
        ]
    ]
    
    // Phrases that indicate mixed emotions
    private let emotionalTransitions: [String] = [
        "but then",
        "and then",
        "but also",
        "while also",
        "at the same time",
        "sometimes",
        "other times"
    ]
    
    func analyzeEmotion(_ text: String) -> EmotionalState {
        let lowercasedText = text.lowercased()
        var emotionScores: [String: Int] = [:]
        var detectedEmotions: Set<String> = []
        var baseIntensity = 5  // Start at middle intensity
        
        // Analyze emotion patterns
        for (emotion, patterns) in emotionalPatterns {
            var score = 0
            for pattern in patterns {
                if lowercasedText.contains(pattern) {
                    score += 1
                    detectedEmotions.insert(emotion)
                }
            }
            if score > 0 {
                emotionScores[emotion] = score
            }
        }
        
        // Analyze intensity phrases
        for (phrase, value) in intensityPhrases {
            if lowercasedText.contains(phrase) {
                baseIntensity += value
            }
        }
        
        // Check for emotional transitions indicating mixed feelings
        var isComplexEmotion = false
        for transition in emotionalTransitions {
            if lowercasedText.contains(transition) {
                isComplexEmotion = true
                break
            }
        }
        
        // Adjust intensity based on context
        if isComplexEmotion {
            baseIntensity += 1  // Mixed emotions often indicate deeper processing
        }
        
        let finalIntensity = min(max(baseIntensity, 1), 10)
        
        let primaryEmotion = emotionScores.max(by: { $0.value < $1.value })?.key ?? "mixed"
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
        let responses: [String: [String]] = [
            "deep_grief": [
                "I hear the depth of your loss, and I want you to know that your pain matters. The space they left behind feels impossible to fill, and that's because their place in your life was so meaningful. Would you like to tell me more about what you're missing most right now?",
                "The weight of their absence is so heavy, and it's completely natural to feel this overwhelmed. Your heart is processing one of the deepest kinds of pain we can experience. I'm here to sit with you in this difficult space for as long as you need.",
                "When someone we love becomes a memory, it can feel like the world has stopped making sense. Your grief is a reflection of the love you shared. Take all the time you need to feel this - there's no timeline for healing."
            ],
            "raw_pain": [
                "That physical ache you're describing - that's your love and your loss speaking. Your body remembers too, and it's okay to feel this pain so deeply. Sometimes just breathing through these moments is the bravest thing we can do. What do you need right now?",
                "When grief hits this hard, it can feel like we're breaking apart. But you're not alone in this moment. Your pain is heard, and it's valid. Would you like to tell me more about what you're feeling?",
                "The raw edges of grief can feel overwhelming, and it's okay if you need to take this moment by moment. I'm here to witness your pain without trying to fix it. Sometimes being heard is what we need most."
            ],
            "anger": [
                "Your anger is so valid - this huge loss wasn't supposed to happen this way. It's unfair and devastating, and you have every right to feel this fury. Sometimes anger is how our heart protests against a reality we never wanted. What makes you the angriest about all of this?",
                "I hear the anger in your words, and it makes complete sense. Anger can be a natural guardian of our grief, protecting us when the pain feels too much. You don't need to apologize for these feelings - they're part of loving someone deeply.",
                "When life shatters our expectations like this, anger is a natural response. It's okay to be angry at the situation, at the timing, at the unfairness of it all. Your feelings are valid, and I'm here to listen without judgment."
            ],
            "guilt": [
                "Those 'what ifs' and 'should haves' can be so heavy to carry. Please know that having regrets doesn't mean you did anything wrong - it just means you wish things could have been different, and that's a natural part of loving someone. Would you like to share what's weighing on your heart?",
                "I hear the guilt in your words, and I want you to know that having these feelings doesn't mean they're true. Grief often comes with guilt, but you loved them the best way you knew how. Can you try to be as gentle with yourself as you would be with a friend feeling this way?",
                "When we lose someone we love, it's common to replay moments and wish we could change things. But love isn't about perfection - it's about the whole journey you shared together. Your love for them shines through even in these difficult feelings."
            ],
            "anxiety": [
                "It's natural for grief to make us worry about what comes next. The future looks different now, and that uncertainty can feel overwhelming. Let's take it one moment at a time together. What's on your mind right now?",
                "When we lose someone, it can shake our sense of security and make everything feel uncertain. Your worries are valid, and you don't have to figure everything out right now. I'm here to listen and support you as you navigate this new territory.",
                "The anxiety you're feeling is a natural response to such a big change in your life. Your mind is trying to make sense of a world that feels different now. Would you like to talk about what's making you most anxious?"
            ],
            "numbness": [
                "Sometimes when our emotions are too intense, our mind protects us by numbing things for a while. It's like your heart taking a necessary break from the intensity of grief. This numbness won't last forever, but for now, it's okay to be where you are.",
                "Feeling numb or disconnected can be unsettling, but it's actually a normal part of grief. Your mind is giving you the space you need to process things gradually. You don't have to force yourself to feel differently.",
                "The numbness you're experiencing might feel strange or wrong, but it's your mind's way of helping you cope with overwhelming emotions. It's temporary, and there's no right or wrong way to feel during grief."
            ],
            "longing": [
                "Those memories you're sharing are so precious - they show how deep your connection was. It's natural to long for more time, more moments, more chances to say all the things in your heart. Would you like to tell me about a special memory you're holding close right now?",
                "Missing them is another way of loving them, and that love doesn't end. Each memory is like a thread connecting you to them. Sometimes those threads can feel painful to touch, but they're also precious reminders of what you shared.",
                "The way you miss them speaks to how meaningful your relationship was. Those moments you shared are forever part of your story. What do you wish you could share with them right now?"
            ],
            "acceptance": [
                "I hear you finding ways to move forward while keeping their memory close. Each small step you take is significant, even when it feels hard. You're learning to carry this loss in your own way, and that takes incredible strength.",
                "Moving forward doesn't mean leaving them behind - it means finding new ways to carry their love with you. I hear you working through this day by day, and that takes real courage. How are you taking care of yourself through this journey?",
                "The way you're navigating this grief shows such resilience. It's okay to have better moments - they don't diminish your love or your loss. You're honoring them by finding your way forward while keeping them in your heart."
            ],
            "love": [
                "The love you're expressing is so beautiful - it's clear how deeply they touched your life. Love doesn't end with loss; it just changes form. Would you like to tell me more about what made your relationship so special?",
                "I can hear how much love there is in your memories. That kind of love leaves an imprint on our hearts that time can't erase. Thank you for sharing these precious feelings with me.",
                "The way you speak about them shows such deep love and appreciation. Those bonds of love continue to connect us even when we can't be together physically. What qualities do you cherish most about them?"
            ],
            "hope": [
                "Those moments of peace, however brief, are like small lights in the darkness. They don't take away the loss, but they show that your heart is still capable of feeling warmth. That's not a betrayal of your grief - it's a testament to your resilience.",
                "I'm glad you're having some gentler moments. Finding spots of light doesn't mean you're 'moving on' - it means you're learning to carry both your grief and your joy, which takes incredible strength. Would you like to tell me more about what brought you this moment of peace?",
                "These glimpses of hope are so precious. They remind us that while grief changes us, it doesn't diminish our capacity for finding meaning and moments of grace. You're honoring them by allowing yourself these breaths of peace."
            ],
            "mixed": [
                "Grief isn't a straight line - it's more like waves that bring different emotions at different times. All of these feelings are valid, even when they seem to contradict each other. Would you like to explore what you're experiencing right now?",
                "It's completely natural to feel many things at once - that's part of how complex and deep your connection was. Your heart is big enough to hold all of these emotions, and you don't have to sort them out alone. I'm here to listen and understand.",
                "When we lose someone we love, our feelings can be as complicated as the relationship itself. There's no 'right' way to grieve, and all of your emotions deserve space and acknowledgment. What feels most present for you in this moment?"
            ]
        ]
        
        guard let baseResponses = responses[state.primaryEmotion],
              let response = baseResponses.randomElement() else {
            return "I hear you. Tell me more?"
        }
        
        if state.intensity >= 8 {
            return response + " Do you need someone to talk to right now? I can help you find support."
        }
        
        if !state.mixedEmotions.isEmpty {
            return response + " It's okay to feel \(state.primaryEmotion) and \(state.mixedEmotions[0]) at the same time."
        }
        
        return response
    }
}

// Test scenarios
let testScenarios = [
    "I really miss my mom. It hurts so much I can't even breathe sometimes.",
    "I'm so angry this happened. But then I feel guilty for being angry.",
    "Some days I just feel numb. Like I'm just going through the motions.",
    "I'm really worried about the holidays. I can't stop thinking about it.",
    "Today I found her old recipe book and actually smiled for a bit.",
    "I feel completely lost without her, but trying to stay strong."
]

print("Testing Enhanced Emotional AI...\n")

let analyzer = EmotionalAnalyzer()

for (index, scenario) in testScenarios.enumerated() {
    print("\nTest \(index + 1): \"\(scenario)\"")
    
    let emotionalState = analyzer.analyzeEmotion(scenario)
    print("Emotional Analysis:")
    print("- Primary Emotion: \(emotionalState.primaryEmotion)")
    print("- Intensity: \(emotionalState.intensity)/10")
    print("- Mixed Emotions: \(emotionalState.mixedEmotions.joined(separator: ", "))")
    
    let response = analyzer.generateResponse(to: emotionalState)
    print("\nAI Response:")
    print(response)
    print("\n---")
}
