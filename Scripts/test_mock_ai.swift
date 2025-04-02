import Foundation
import EverNear

// Test scenarios that show emotional progression
let conversationScenarios = [
    // Initial grief and shock
    "I can't believe my mother is gone. It hurts so much.",
    
    // Mixed emotions and memories
    "Sometimes I laugh remembering the silly things she used to do, but then I feel guilty for laughing.",
    
    // Anger and frustration
    "I'm so mad - why did this have to happen? It's not fair.",
    
    // Anxiety about the future
    "I'm really worried about the holidays coming up. I don't know how to handle them without her.",
    
    // Signs of coping
    "Today I made her special recipe. I cried a bit, but it felt good to remember her this way.",
    
    // Complex emotions
    "I feel stronger some days, but then something small reminds me of her and I'm a mess again."
]

print("Testing Enhanced Emotional AI Responses...\n")

let mockService = MockAIService.shared
var completedTests = 0

for (index, scenario) in conversationScenarios.enumerated() {
    print("\nTest \(index + 1): \"\(scenario)\"")
    
    mockService.generateResponse(to: scenario) { result in
        switch result {
        case .success(let response):
            print("AI: \(response)")
        case .failure(let error):
            print("Error: \(error)")
        }
        completedTests += 1
        if completedTests == conversationScenarios.count {
            exit(0)
        }
    }
    
    // Small delay between tests to maintain conversation flow
    Thread.sleep(forTimeInterval: 1.0)
}

RunLoop.main.run()
