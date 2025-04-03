import Foundation

struct Memory {
    let id: UUID
    let category: MemoryCategory
    let content: String
    let date: Date
    let emotionalState: EmotionalState?
    let personName: String?
    let location: String?
    let mediaUrls: [URL]?
    
    enum MemoryCategory: String {
        case magicalMoments = "Magical Moments"
        case heartfeltFeelings = "Heartfelt Feelings"
        case lifeUpdates = "Life Updates"
        case difficultTimes = "Difficult Times"
        case sharedWins = "Shared Wins"
    }
}

class MemoryManager {
    static let shared = MemoryManager()
    private var memories: [Memory] = []
    
    // Get relevant memories for the current conversation
    func getRelevantMemories(forPerson name: String, emotion: String, limit: Int = 3) -> [Memory] {
        return memories
            .filter { $0.personName?.lowercased() == name.lowercased() }
            .filter { memory in
                switch emotion.lowercased() {
                case "deep_grief", "raw_pain":
                    return memory.category == .magicalMoments || memory.category == .heartfeltFeelings
                case "anger", "anxiety":
                    return memory.category == .difficultTimes || memory.category == .heartfeltFeelings
                case "hope", "acceptance":
                    return memory.category == .magicalMoments || memory.category == .sharedWins
                default:
                    return true
                }
            }
            .sorted { $0.date > $1.date }
            .prefix(limit)
            .map { $0 }
    }
    
    // Get memory prompts based on emotional state
    func getMemoryPrompt(forEmotion emotion: String) -> String {
        let prompts: [String: [String]] = [
            "deep_grief": [
                "What's a small moment with them that always makes you smile?",
                "Is there a special tradition or habit you shared that you'd like to tell me about?",
                "What's something they taught you that you carry with you?"
            ],
            "raw_pain": [
                "Would you like to share a peaceful memory of them?",
                "What's a simple moment with them that meant a lot to you?",
                "Is there a funny story about them that still makes you laugh?"
            ],
            "anger": [
                "What would they say to comfort you in this moment?",
                "Is there a memory of them that helps you feel calmer?",
                "What wisdom would they share with you right now?"
            ],
            "anxiety": [
                "What's a time they helped you feel brave?",
                "Can you remember how they supported you through difficult times?",
                "What would they say to reassure you?"
            ],
            "hope": [
                "Would you like to share more happy memories of them?",
                "What's a tradition of theirs you'd like to continue?",
                "How do you feel their presence in your life today?"
            ],
            "acceptance": [
                "What values of theirs do you see in yourself?",
                "How has their love shaped who you are?",
                "What parts of them live on through you?"
            ]
        ]
        
        return prompts[emotion]?.randomElement() ?? "Would you like to share a memory about them?"
    }
    
    // Add a new memory
    func addMemory(_ memory: Memory) {
        memories.append(memory)
    }
    
    // Get memories by category
    func getMemories(category: Memory.MemoryCategory) -> [Memory] {
        return memories.filter { $0.category == category }
    }
    
    // Get memories for a specific person
    func getMemories(forPerson name: String) -> [Memory] {
        return memories.filter { $0.personName?.lowercased() == name.lowercased() }
    }
}
