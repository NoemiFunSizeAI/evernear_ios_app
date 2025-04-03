import UIKit

class MemoryResponseGenerator {
    // Singleton instance
    static let shared = MemoryResponseGenerator()
    
    // Private initializer for singleton
    private init() {}
    
    // MARK: - Memory-Based Responses
    
    func generateMemoryPrompt(based on emotion: Emotion) -> String {
        switch emotion {
        case .grief:
            return generateGriefMemoryPrompt()
        case .sadness:
            return generateSadnessMemoryPrompt()
        case .anger:
            return generateAngerMemoryPrompt()
        case .fear, .anxiety:
            return generateAnxietyMemoryPrompt()
        case .joy:
            return generateJoyMemoryPrompt()
        case .gratitude:
            return generateGratitudeMemoryPrompt()
        case .nostalgia:
            return generateNostalgiaMemoryPrompt()
        case .confusion:
            return generateConfusionMemoryPrompt()
        case .neutral:
            return generateNeutralMemoryPrompt()
        }
    }
    
    func suggestMemoryBasedResponse(for userMessage: String, userProfile: UserProfile) -> String {
        // Analyze emotion in user message
        let emotionResult = EmotionalResponseAnalyzer.shared.analyzeEmotion(in: userMessage)
        
        // Get relevant memories based on emotion
        let relevantMemories = findRelevantMemories(for: emotionResult.dominantEmotion)
        
        // If we have relevant memories, generate a response that references them
        if let memory = relevantMemories.first {
            return generateResponseWithMemoryReference(memory: memory, emotion: emotionResult.dominantEmotion, userProfile: userProfile)
        } else {
            // If no relevant memories, suggest creating one
            return generateMemoryPrompt(based: emotionResult.dominantEmotion)
        }
    }
    
    // MARK: - Memory Retrieval
    
    func findRelevantMemories(for emotion: Emotion, limit: Int = 3) -> [Memory] {
        // Get all memories
        let allMemories = DataManager.shared.memories
        
        // Define keywords for each emotion
        let keywords: [String]
        
        switch emotion {
        case .grief, .sadness:
            keywords = ["miss", "loss", "sad", "grief", "cry", "tears", "remember", "gone"]
        case .anger:
            keywords = ["angry", "mad", "frustrat", "unfair", "upset"]
        case .fear, .anxiety:
            keywords = ["fear", "afraid", "scared", "worry", "anxious", "stress"]
        case .joy:
            keywords = ["happy", "joy", "laugh", "smile", "fun", "enjoy"]
        case .gratitude:
            keywords = ["grateful", "thankful", "appreciate", "blessed", "thank"]
        case .nostalgia:
            keywords = ["remember", "used to", "back then", "childhood", "old times"]
        case .confusion:
            keywords = ["confus", "uncertain", "unsure", "wonder"]
        case .neutral:
            keywords = []
        }
        
        // If no keywords or no memories, return empty array
        if keywords.isEmpty || allMemories.isEmpty {
            return []
        }
        
        // Score each memory based on keyword matches
        var scoredMemories: [(memory: Memory, score: Int)] = []
        
        for memory in allMemories {
            var score = 0
            let content = memory.content.lowercased()
            let title = memory.title.lowercased()
            
            for keyword in keywords {
                if content.contains(keyword) || title.contains(keyword) {
                    score += 1
                }
            }
            
            if score > 0 {
                scoredMemories.append((memory: memory, score: score))
            }
        }
        
        // Sort by score (highest first) and return top results
        let sortedMemories = scoredMemories.sorted { $0.score > $1.score }
        return sortedMemories.prefix(limit).map { $0.memory }
    }
    
    // MARK: - Response Generation
    
    private func generateResponseWithMemoryReference(memory: Memory, emotion: Emotion, userProfile: UserProfile) -> String {
        let lovedOneName = userProfile.lovedOneName
        let memoryTitle = memory.title
        let memoryDate = formatDate(memory.date)
        
        let responses = [
            "I noticed you're feeling \(emotion). This reminds me of a memory you shared about \(lovedOneName) titled '\(memoryTitle)' from \(memoryDate). Would you like to revisit that memory?",
            
            "Your words remind me of something you shared before about \(lovedOneName). You created a memory called '\(memoryTitle)'. Would it help to look at that again?",
            
            "I remember you shared a memory about \(lovedOneName) called '\(memoryTitle)'. That might be relevant to how you're feeling now. Would you like to see it?",
            
            "When you express these feelings, I'm reminded of your memory '\(memoryTitle)' about \(lovedOneName). Would revisiting that memory be helpful right now?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    // MARK: - Memory Prompt Generation
    
    private func generateGriefMemoryPrompt() -> String {
        let prompts = [
            "Would you like to create a memory about a time when your loved one made you feel especially loved or valued?",
            
            "Sometimes capturing memories about the little everyday moments can be healing. Is there a simple, ordinary moment with your loved one that you'd like to preserve?",
            
            "Would it help to record a memory about a tradition or ritual you shared with your loved one that was meaningful to both of you?",
            
            "Would you like to create a memory about something your loved one taught you that continues to impact your life?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateSadnessMemoryPrompt() -> String {
        let prompts = [
            "Would creating a memory about a time your loved one made you laugh help lift your spirits right now?",
            
            "Sometimes remembering the joy can help balance the sadness. Would you like to record a memory about a particularly happy moment you shared?",
            
            "Would it be comforting to create a memory about something your loved one did that always made you smile?",
            
            "Would you like to preserve a memory about a quality you admired in your loved one that brings you comfort when you think about it?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateAngerMemoryPrompt() -> String {
        let prompts = [
            "Would it help to balance these feelings by creating a memory about a time when your loved one helped you through a difficult situation?",
            
            "Sometimes remembering the whole person can help process complex emotions. Would you like to record a memory about a time your loved one showed understanding or patience?",
            
            "Would creating a memory about how your loved one dealt with their own frustrations or anger provide any perspective?",
            
            "Would you like to preserve a memory about a disagreement that you and your loved one worked through together?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateAnxietyMemoryPrompt() -> String {
        let prompts = [
            "Would it help to create a memory about a time when your loved one helped you feel safe or secure?",
            
            "Sometimes remembering moments of calm can help during anxious times. Would you like to record a memory about a peaceful moment you shared?",
            
            "Would you like to preserve a memory about how your loved one handled uncertainty or challenging times?",
            
            "Would creating a memory about a time when your loved one provided comfort during a difficult situation help right now?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateJoyMemoryPrompt() -> String {
        let prompts = [
            "It's wonderful to experience joy. Would you like to capture this moment as a memory to revisit during harder times?",
            
            "Would you like to create a memory about what's bringing you joy right now and how it connects to your loved one?",
            
            "Would you like to preserve a memory about a time when your loved one contributed to your happiness in a similar way?",
            
            "Would creating a memory about how your loved one would respond to your current joy be meaningful?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateGratitudeMemoryPrompt() -> String {
        let prompts = [
            "Would you like to create a memory about something specific your loved one did that you're particularly grateful for?",
            
            "Gratitude is a beautiful emotion to preserve. Would you like to record a memory about the qualities in your loved one that you're most thankful for?",
            
            "Would you like to preserve a memory about how your loved one expressed gratitude or appreciation?",
            
            "Would creating a memory about how your relationship with your loved one has shaped what you value and appreciate be meaningful?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateNostalgiaMemoryPrompt() -> String {
        let prompts = [
            "Would you like to capture more details about this nostalgic memory to preserve it more fully?",
            
            "Nostalgic memories are precious. Would you like to record more about the context or setting of this memory?",
            
            "Would you like to preserve any sensory details from this memory - like sounds, smells, or tastes that were part of the experience?",
            
            "Would creating a more detailed memory about the emotions you felt during this time help preserve its significance?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateConfusionMemoryPrompt() -> String {
        let prompts = [
            "Would it help to create a memory about a time when your loved one helped you find clarity during a confusing situation?",
            
            "Sometimes remembering how we've navigated uncertainty before can help. Would you like to record a memory about how your loved one approached confusion or uncertainty?",
            
            "Would you like to preserve a memory about a time when things felt unclear but eventually made sense?",
            
            "Would creating a memory about wisdom or advice your loved one shared that might apply to your current situation be helpful?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    private func generateNeutralMemoryPrompt() -> String {
        let prompts = [
            "Would you like to create a new memory about your loved one today? It could be about anything that feels significant to you.",
            
            "Is there a memory about your loved one that you haven't recorded yet that you'd like to preserve?",
            
            "Would you like to capture a memory about an ordinary day or routine you shared with your loved one?",
            
            "Would creating a memory about something your loved one enjoyed or was passionate about feel meaningful today?"
        ]
        
        return prompts.randomElement() ?? prompts[0]
    }
    
    // MARK: - Helper Methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
