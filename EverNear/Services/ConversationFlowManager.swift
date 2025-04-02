import Foundation

class ConversationFlowManager: ObservableObject {
    @Published var currentContext: ConversationContext
    private let emotionAnalyzer: VoiceEmotionAnalyzer
    private var conversationHistory: [ConversationTurn] = []
    private var memoryContext: [String: Any] = [:]
    
    struct ConversationTurn {
        let userMessage: String
        let emotion: VoiceEmotionAnalyzer.EmotionState
        let timestamp: Date
        let response: String
    }
    
    struct ConversationContext {
        var topic: Topic
        var emotionalState: VoiceEmotionAnalyzer.EmotionState
        var intensity: Double
        var supportLevel: SupportLevel
        var memoryReferences: [String]
        
        enum Topic {
            case greeting
            case grief
            case memories
            case dailyUpdate
            case support
            case reflection
        }
        
        enum SupportLevel {
            case listening
            case acknowledging
            case exploring
            case supporting
            case guiding
        }
    }
    
    init(emotionAnalyzer: VoiceEmotionAnalyzer) {
        self.emotionAnalyzer = emotionAnalyzer
        self.currentContext = ConversationContext(
            topic: .greeting,
            emotionalState: .neutral,
            intensity: 0.0,
            supportLevel: .listening,
            memoryReferences: []
        )
    }
    
    func processUserInput(_ text: String) -> String {
        // Update emotional context
        updateEmotionalContext(text)
        
        // Generate appropriate response
        let response = generateResponse(to: text)
        
        // Store conversation turn
        let turn = ConversationTurn(
            userMessage: text,
            emotion: emotionAnalyzer.currentEmotion,
            timestamp: Date(),
            response: response
        )
        conversationHistory.append(turn)
        
        return response
    }
    
    private func updateEmotionalContext(_ text: String) {
        // Update emotion state
        emotionAnalyzer.analyzeText(text)
        currentContext.emotionalState = emotionAnalyzer.currentEmotion
        currentContext.intensity = emotionAnalyzer.emotionConfidence
        
        // Determine topic and support level
        updateTopic(from: text)
        updateSupportLevel()
    }
    
    private func updateTopic(from text: String) {
        let lowercased = text.lowercased()
        
        if lowercased.contains("remember") || lowercased.contains("memory") {
            currentContext.topic = .memories
        } else if lowercased.contains("miss") || lowercased.contains("gone") {
            currentContext.topic = .grief
        } else if lowercased.contains("today") || lowercased.contains("feeling") {
            currentContext.topic = .dailyUpdate
        } else if lowercased.contains("help") || lowercased.contains("support") {
            currentContext.topic = .support
        } else if lowercased.contains("think") || lowercased.contains("reflect") {
            currentContext.topic = .reflection
        }
    }
    
    private func updateSupportLevel() {
        switch (currentContext.emotionalState, currentContext.intensity) {
        case (.grief, _), (.sadness, let intensity) where intensity > 0.7:
            currentContext.supportLevel = .supporting
        case (.fear, _), (.anger, _):
            currentContext.supportLevel = .acknowledging
        case (.joy, _):
            currentContext.supportLevel = .exploring
        default:
            currentContext.supportLevel = .listening
        }
    }
    
    private func generateResponse(to text: String) -> String {
        // Get response template based on context
        let template = getResponseTemplate()
        
        // Personalize response with emotional context
        return personalizeResponse(template)
    }
    
    private func getResponseTemplate() -> String {
        switch (currentContext.topic, currentContext.supportLevel) {
        case (.grief, .supporting):
            return "I hear how much pain you're feeling. It's completely natural to [emotion] when we lose someone we love. Would you like to tell me more about what you're experiencing?"
            
        case (.memories, .exploring):
            return "That sounds like a precious memory. How do you feel when you think about [memory]? Would you like to share more about that time?"
            
        case (.dailyUpdate, .listening):
            return "Thank you for sharing how you're feeling today. I notice that you seem [emotion]. What's contributing to that feeling?"
            
        case (.support, .guiding):
            return "I'm here to support you. Based on what you're sharing, would it help to [suggestion]? We can also explore other ways to help you through this."
            
        case (.reflection, .acknowledging):
            return "It's important to give yourself space to process these feelings. I hear that you're feeling [emotion]. What thoughts are coming up for you right now?"
            
        default:
            return "I'm here with you. Would you like to tell me more about what's on your mind?"
        }
    }
    
    private func personalizeResponse(_ template: String) -> String {
        var response = template
        
        // Replace emotion placeholder
        response = response.replacingOccurrences(
            of: "[emotion]",
            with: emotionAnalyzer.currentEmotion.description
        )
        
        // Replace memory placeholder if available
        if let recentMemory = currentContext.memoryReferences.last {
            response = response.replacingOccurrences(
                of: "[memory]",
                with: recentMemory
            )
        }
        
        // Replace suggestion based on emotional state
        let suggestion = getSupportSuggestion()
        response = response.replacingOccurrences(
            of: "[suggestion]",
            with: suggestion
        )
        
        return response
    }
    
    private func getSupportSuggestion() -> String {
        switch currentContext.emotionalState {
        case .grief, .sadness:
            return "take a moment to honor these feelings and perhaps light a candle in remembrance"
        case .fear:
            return "try some gentle breathing exercises together"
        case .anger:
            return "find a safe way to express these strong emotions, maybe through writing or movement"
        case .joy:
            return "celebrate this moment and perhaps create a new memory to cherish"
        case .neutral:
            return "explore what you're feeling more deeply"
        }
    }
    
    func getVoiceParameters() -> VoiceEmotionAnalyzer.VoiceAdjustment {
        // Get voice parameters optimized for current emotional context
        return emotionAnalyzer.getVoiceAdjustment()
    }
    
    func recordMemoryReference(_ memory: String) {
        currentContext.memoryReferences.append(memory)
    }
    
    func resetContext() {
        currentContext = ConversationContext(
            topic: .greeting,
            emotionalState: .neutral,
            intensity: 0.0,
            supportLevel: .listening,
            memoryReferences: []
        )
        emotionAnalyzer.reset()
    }
}
