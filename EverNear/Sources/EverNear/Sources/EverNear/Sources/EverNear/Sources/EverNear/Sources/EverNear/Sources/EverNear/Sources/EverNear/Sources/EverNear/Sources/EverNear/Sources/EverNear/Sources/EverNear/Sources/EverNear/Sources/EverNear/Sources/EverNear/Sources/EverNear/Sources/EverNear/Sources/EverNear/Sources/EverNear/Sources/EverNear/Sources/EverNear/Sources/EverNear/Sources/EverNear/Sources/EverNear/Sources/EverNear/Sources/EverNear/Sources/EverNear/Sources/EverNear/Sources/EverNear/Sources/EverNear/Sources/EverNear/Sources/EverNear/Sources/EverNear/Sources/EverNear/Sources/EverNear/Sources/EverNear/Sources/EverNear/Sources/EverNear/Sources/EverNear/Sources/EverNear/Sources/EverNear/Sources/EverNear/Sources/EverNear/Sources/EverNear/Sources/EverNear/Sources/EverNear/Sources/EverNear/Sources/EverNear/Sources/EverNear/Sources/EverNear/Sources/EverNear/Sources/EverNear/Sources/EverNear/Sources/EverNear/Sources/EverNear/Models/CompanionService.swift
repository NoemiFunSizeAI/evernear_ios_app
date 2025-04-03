import UIKit

class CompanionService {
    // Singleton instance
    static let shared = CompanionService()
    
    // Private initializer for singleton
    private init() {
        loadPresetResponses()
    }
    
    // MARK: - Properties
    
    private var presetResponses: [String: [String]] = [:]
    private var currentConversation: Conversation?
    
    // MARK: - Conversation Management
    
    func startNewConversation() -> Conversation {
        let conversation = Conversation()
        currentConversation = conversation
        return conversation
    }
    
    func getCurrentConversation() -> Conversation {
        if currentConversation == nil {
            currentConversation = startNewConversation()
        }
        return currentConversation!
    }
    
    func addUserMessage(_ content: String) -> Message {
        let message = Message(content: content, isUser: true)
        var conversation = getCurrentConversation()
        conversation.messages.append(message)
        
        // Update conversation title if it's the default and this is the first message
        if conversation.title == "New Conversation" && conversation.messages.count == 1 {
            let title = generateConversationTitle(from: content)
            conversation.title = title
        }
        
        currentConversation = conversation
        DataManager.shared.saveConversation(conversation)
        
        return message
    }
    
    func generateCompanionResponse(to userMessage: String, completion: @escaping (Message) -> Void) {
        let conversation = getCurrentConversation()
        
        AIService.shared.generateResponse(to: userMessage, context: conversation.messages) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let message = Message(content: response, isUser: false)
                    conversation.messages.append(message)
                    self.currentConversation = conversation
                    DataManager.shared.saveConversation(conversation)
                    completion(message)
                    
                case .failure(let error):
                    // Handle error with appropriate user-friendly message
                    let errorMessage: String
                    switch error {
                    case .apiKeyMissing:
                        errorMessage = AIConfig.shared.apiKeyMissingError
                    case .networkError:
                        errorMessage = AIConfig.shared.networkError
                    default:
                        errorMessage = AIConfig.shared.unexpectedError
                    }
                    
                    let message = Message(content: errorMessage, isUser: false)
                    completion(message)
                }
            }
        }
        
        // Simulate typing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let response = self.generateResponse(to: userMessage)
            let message = Message(content: response, isUser: false)
            
            var conversation = self.getCurrentConversation()
            conversation.messages.append(message)
            self.currentConversation = conversation
            DataManager.shared.saveConversation(conversation)
            
            completion(message)
        }
    }
    
    // MARK: - Response Generation
    
    private func generateResponse(to userMessage: String) -> String {
        let lowercasedMessage = userMessage.lowercased()
        
        // Check for emotional keywords
        if containsAny(lowercasedMessage, keywords: ["sad", "down", "depressed", "unhappy", "miss", "missing"]) {
            return getRandomResponse(for: "sadness")
        } else if containsAny(lowercasedMessage, keywords: ["happy", "joy", "grateful", "thankful", "appreciate"]) {
            return getRandomResponse(for: "happiness")
        } else if containsAny(lowercasedMessage, keywords: ["angry", "frustrated", "upset", "mad"]) {
            return getRandomResponse(for: "anger")
        } else if containsAny(lowercasedMessage, keywords: ["anxious", "worried", "scared", "fear", "afraid"]) {
            return getRandomResponse(for: "anxiety")
        } else if containsAny(lowercasedMessage, keywords: ["memory", "remember", "reminisce", "recall", "story"]) {
            return getRandomResponse(for: "memories")
        } else if containsAny(lowercasedMessage, keywords: ["cope", "help", "advice", "suggestion", "how do i"]) {
            return getRandomResponse(for: "coping")
        } else if containsAny(lowercasedMessage, keywords: ["thank", "thanks", "appreciate"]) {
            return getRandomResponse(for: "gratitude")
        } else if isGreeting(lowercasedMessage) {
            return getRandomResponse(for: "greeting")
        } else {
            return getRandomResponse(for: "general")
        }
    }
    
    private func containsAny(_ text: String, keywords: [String]) -> Bool {
        for keyword in keywords {
            if text.contains(keyword) {
                return true
            }
        }
        return false
    }
    
    private func isGreeting(_ text: String) -> Bool {
        let greetings = ["hello", "hi", "hey", "good morning", "good afternoon", "good evening", "greetings"]
        return containsAny(text, keywords: greetings)
    }
    
    private func getRandomResponse(for category: String) -> String {
        guard let responses = presetResponses[category], !responses.isEmpty else {
            return "I'm here to listen and support you."
        }
        
        let randomIndex = Int.random(in: 0..<responses.count)
        return responses[randomIndex]
    }
    
    private func generateConversationTitle(from firstMessage: String) -> String {
        // Extract first few words for title
        let words = firstMessage.split(separator: " ")
        let titleWords = words.prefix(3).joined(separator: " ")
        
        if titleWords.isEmpty {
            return "New Conversation"
        } else {
            return titleWords + "..."
        }
    }
    
    // MARK: - Preset Responses
    
    private func loadPresetResponses() {
        presetResponses = [
            "greeting": [
                "Hello there. How are you feeling today?",
                "Hi, it's good to connect with you. How can I support you today?",
                "I'm here for you. How are you doing right now?"
            ],
            "sadness": [
                "I understand that sadness can feel overwhelming. Would you like to talk about what's bringing up these feelings today?",
                "It's okay to feel sad. Your grief is a reflection of the love you have for them. Would you like to share more about what you're experiencing?",
                "I'm here with you in this difficult moment. Sometimes sharing a memory of your loved one can bring some comfort. Would you like to tell me about a special memory?",
                "Grief comes in waves, and it's okay to feel sad. Would it help to talk about specific things you're missing about them right now?"
            ],
            "happiness": [
                "It's wonderful to hear you're experiencing some joy. Those moments are precious. Would you like to share what brought this happiness?",
                "I'm glad you're having a positive moment. Would you like to capture this as a memory to look back on?",
                "Those moments of happiness are so important. Would you like to tell me more about what's bringing you joy today?"
            ],
            "anger": [
                "Anger is a natural part of grief. It's okay to feel frustrated by your loss. Would you like to talk more about what's triggering these feelings?",
                "I hear that you're feeling angry, and that's completely valid. Sometimes it helps to express those feelings in a safe space. Would you like to share more?",
                "Anger often comes from a place of deep love and loss. Would it help to talk about the specific things that are frustrating you right now?"
            ],
            "anxiety": [
                "It sounds like you're feeling anxious. That's very common during grief. Would taking a few deep breaths together help?",
                "Anxiety can be overwhelming. Would it help to focus on something grounding, like sharing a peaceful memory of your loved one?",
                "I understand those worried feelings. Sometimes anxiety comes from the changes grief brings to our lives. Would you like to talk about what specific concerns are on your mind?"
            ],
            "memories": [
                "I'd love to hear about that memory. Sharing memories can be a meaningful way to honor your loved one. What details stand out to you most?",
                "Thank you for sharing this memory with me. Would you like to add any photos or record your voice telling this story to preserve it?",
                "That sounds like a special memory. How does recalling this moment make you feel?"
            ],
            "coping": [
                "Grief is a unique journey for everyone. Some find comfort in creating rituals, others in talking about their loved ones. What has brought you moments of peace so far?",
                "Taking care of yourself is important during grief. Have you been able to maintain small routines for self-care?",
                "Many people find that connecting with others who understand their loss can help. Would you be interested in exploring support groups or connecting with friends who knew your loved one?"
            ],
            "gratitude": [
                "You're welcome. I'm here to support you through this journey.",
                "I'm glad I could help in some small way. Is there anything else you'd like to talk about?",
                "It's my purpose to be here for you. How else can I support you today?"
            ],
            "general": [
                "Thank you for sharing that with me. Would you like to explore this further, or perhaps recall a special memory of your loved one?",
                "I appreciate you opening up. How has this been affecting you lately?",
                "I'm here to listen and support you. Would you like to tell me more about how you've been feeling?",
                "Your feelings are valid and important. Would it help to talk about a specific memory or concern?"
            ]
        ]
    }
}
