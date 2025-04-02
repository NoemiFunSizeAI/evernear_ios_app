import Foundation

class MockAIService {
    private let conversationMemory = ConversationMemory()
    private let emotionalAnalyzer = EmotionalAnalyzer()
    static let shared = MockAIService()
    
    private init() {}
    
    private struct PersonInfo {
        let name: String
        let relationship: String?
        let qualities: Set<String>?
        let memory: String?
    }
    
    private func extractPersonReference(from text: String) -> PersonInfo? {
        let text = text.lowercased()
        let words = text.split(separator: " ").map(String.init)
        
        // Common relationship indicators
        let relationships = [
            "mom": "mother", "mother": "mother", "dad": "father", "father": "father",
            "sister": "sister", "brother": "brother", "wife": "wife", "husband": "husband",
            "partner": "partner", "friend": "friend", "grandma": "grandmother",
            "grandmother": "grandmother", "grandpa": "grandfather", "grandfather": "grandfather",
            "aunt": "aunt", "uncle": "uncle", "daughter": "daughter", "son": "son"
        ]
        
        // Common quality indicators
        let qualityIndicators = ["was", "always", "loved", "enjoyed", "liked"]
        
        // Memory indicators
        let memoryIndicators = ["remember when", "miss", "loved", "used to", "would always"]
        
        var foundName: String? = nil
        var foundRelationship: String? = nil
        var qualities = Set<String>()
        var memory: String? = nil
        
        // Look for relationship mentions
        for (word, relationship) in relationships {
            if text.contains(word) {
                foundRelationship = relationship
                // Look for names near relationship words
                for (i, w) in words.enumerated() {
                    if w == word && i > 0 {
                        let prevWord = words[i-1]
                        if !["my", "our", "the", "a"].contains(prevWord) {
                            foundName = prevWord.capitalized
                        }
                    }
                }
                break
            }
        }
        
        // Extract qualities
        for indicator in qualityIndicators {
            if let range = text.range(of: indicator) {
                let afterIndicator = text[range.upperBound...]
                if let endRange = afterIndicator.firstIndex(where: { ".,!?".contains($0) }) {
                    let quality = String(afterIndicator[..<endRange]).trimmingCharacters(in: .whitespaces)
                    if !quality.isEmpty {
                        qualities.insert(quality)
                    }
                }
            }
        }
        
        // Extract memory
        for indicator in memoryIndicators {
            if let range = text.range(of: indicator) {
                let afterIndicator = text[range.upperBound...]
                if let endRange = afterIndicator.firstIndex(where: { ".!?".contains($0) }) {
                    let memoryText = String(afterIndicator[..<endRange]).trimmingCharacters(in: .whitespaces)
                    if !memoryText.isEmpty {
                        memory = memoryText
                        break
                    }
                }
            }
        }
        
        // If we found a relationship but no name, use the relationship as the identifier
        if foundName == nil && foundRelationship != nil {
            foundName = foundRelationship
        }
        
        guard let name = foundName else { return nil }
        return PersonInfo(name: name, relationship: foundRelationship, qualities: qualities, memory: memory)
    }
    
    private func updatePersonMemory(from text: String, personInfo: PersonInfo) {
        var memories: [String]? = nil
        if let memory = personInfo.memory {
            memories = [memory]
        }
        
        conversationMemory.updatePersonMemory(
            name: personInfo.name,
            relationship: personInfo.relationship,
            qualities: personInfo.qualities,
            memories: memories
        )
    }
    
    private func personalizeResponse(_ baseResponse: String, text: String, emotionalState: EmotionalState) -> String {
        let memoryManager = MemoryManager.shared
        var response = baseResponse
        
        // Get emotional pattern
        let pattern = conversationMemory.getEmotionalPattern()
        
        // If we see a persistent pattern of intense emotions, acknowledge it
        if pattern[emotionalState.primaryEmotion]?.averageIntensity ?? 0 > 7 {
            response += "\n\nI've noticed these feelings have been particularly intense for you lately. Remember that it's okay to take breaks when you need to, and there's no timeline for grief. Would you like to talk about what's making these feelings so strong?"
        }
        
        // If we see a shift in emotional pattern, acknowledge it
        if let previousEmotions = pattern.filter({ $0.key != emotionalState.primaryEmotion }).max(by: { $0.value.count < $1.value.count }) {
            if previousEmotions.value.count > 3 && pattern[emotionalState.primaryEmotion]?.count ?? 0 <= 2 {
                response += "\n\nI notice your feelings have been shifting lately. That's completely natural - grief isn't a straight line, and each day can bring different emotions. How are you making sense of these changes?"
            }
        }
        
        // Add personal context if available
        if let personInfo = extractPersonReference(from: text),
           let context = conversationMemory.getPersonalizedContext(forName: personInfo.name) as? [String: Any] {
           
            // Get relevant memories
            let relevantMemories = memoryManager.getRelevantMemories(forPerson: personInfo.name, emotion: emotionalState.primaryEmotion)
            if !relevantMemories.isEmpty {
                // Add memory-based response
                if let memory = relevantMemories.first {
                    response += "\n\nI remember you telling me about " + memory.content + ". Would you like to share more memories like that?"
                }
            } else {
                // If no memories exist, offer a prompt
                let prompt = memoryManager.getMemoryPrompt(forEmotion: emotionalState.primaryEmotion)
                response += "\n\n" + prompt
            }
            
            // Add quality-based response
            if let qualities = context["qualities"] as? [String],
               !qualities.isEmpty {
                let qualitiesList = qualities.joined(separator: ", ")
                response += "\n\nThe way you describe \(personInfo.name) - \(qualitiesList) - it really shows the beautiful connection you shared. Would you like to tell me more about these special qualities?"
            }
            
            // Add memory-based response
            if let memories = context["memories"] as? [String],
               let recentMemory = memories.last {
                response += "\n\nThank you for sharing that memory about \(personInfo.name). These stories keep their spirit alive in such a meaningful way."
            }
        }
        
        return response
    }
    
    private func checkUpcomingDates() -> String? {
        let upcomingDates = conversationMemory.getUpcomingDates(withinDays: 14)
        guard !upcomingDates.isEmpty else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        for (name, occasion, date) in upcomingDates {
            let dateString = formatter.string(from: date)
            return "\n\nI know \(occasion) for \(name) is coming up on \(dateString). These dates can bring up a lot of emotions. Would you like to talk about how you're feeling about it?"
        }
        
        return nil
    }
    
    // Generate a response based on emotional analysis
    func generateResponse(to text: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Analyze emotional state
        let emotionalState = emotionalAnalyzer.analyzeEmotion(text)
        
        // Record emotional state for pattern analysis
        conversationMemory.recordEmotionalState(emotionalState.primaryEmotion, intensity: emotionalState.intensity)
        
        // Extract person references and update memory
        if let personInfo = extractPersonReference(from: text) {
            updatePersonMemory(from: text, personInfo: personInfo)
        }
        
        // Get base response from emotional analyzer
        var response = emotionalAnalyzer.generateResponse(to: emotionalState)
        
        // Personalize response using conversation memory
        response = personalizeResponse(response, text: text, emotionalState: emotionalState)
        
        // Check for upcoming significant dates
        if let dateContext = checkUpcomingDates() {
            response += "\n" + dateContext
        }
        
        // Simulate brief network delay for more natural interaction
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(.success(response))
        }
    }
}
