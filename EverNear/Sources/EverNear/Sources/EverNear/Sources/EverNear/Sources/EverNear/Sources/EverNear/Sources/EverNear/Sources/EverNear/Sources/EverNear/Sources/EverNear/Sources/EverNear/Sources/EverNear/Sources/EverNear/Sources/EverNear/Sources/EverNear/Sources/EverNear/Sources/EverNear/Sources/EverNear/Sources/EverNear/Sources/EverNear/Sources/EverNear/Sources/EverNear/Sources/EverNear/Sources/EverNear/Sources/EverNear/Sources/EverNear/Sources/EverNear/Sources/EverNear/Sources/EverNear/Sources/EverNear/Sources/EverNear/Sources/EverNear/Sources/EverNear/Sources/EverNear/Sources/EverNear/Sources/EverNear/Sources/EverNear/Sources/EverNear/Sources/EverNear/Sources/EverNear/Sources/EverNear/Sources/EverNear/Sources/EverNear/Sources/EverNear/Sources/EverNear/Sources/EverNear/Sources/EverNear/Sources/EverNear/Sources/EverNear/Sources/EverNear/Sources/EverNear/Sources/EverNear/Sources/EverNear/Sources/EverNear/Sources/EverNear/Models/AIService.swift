import Foundation

enum AIError: Error {
    case apiKeyMissing
    case networkError
    case invalidResponse
    case unexpectedError
}

class AIService {
    static let shared = AIService()
    private let mockService = MockAIService.shared
    private let emotionalAnalyzer = EmotionalResponseAnalyzer()
    
    private init() {}
    
    struct GeminiContent: Codable {
        let role: String
        let parts: [ContentPart]
    }
    
    struct ContentPart: Codable {
        let text: String
    }
    
    struct GeminiRequest: Codable {
        let contents: [GeminiContent]
        let generationConfig: GenerationConfig
        
        enum CodingKeys: String, CodingKey {
            case contents
            case generationConfig = "generationConfig"
        }
    }
    
    struct GenerationConfig: Codable {
        let temperature: Double
        let maxOutputTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case temperature
            case maxOutputTokens = "maxOutputTokens"
        }
    }
    
    struct GeminiResponse: Codable {
        let candidates: [Candidate]
        
        struct Candidate: Codable {
            let content: GeminiContent
        }
    }
    
    func generateResponse(to userMessage: String, context: [Message], completion: @escaping (Result<String, AIError>) -> Void) {
        // Get emotional context for future use
        let emotionalContext = emotionalAnalyzer.analyzeEmotion(from: userMessage)
        
        // Use mock service to generate response
        mockService.generateResponse(to: userMessage) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(_):
                completion(.failure(.unexpectedError))
            }
        }
    }
}
