import Foundation

struct AIConfig {
    static let shared = AIConfig()
    
    // Gemini Configuration
    private let apiKey: String? = ProcessInfo.processInfo.environment["GEMINI_API_KEY"]
    private let baseURL = "https://generativelanguage.googleapis.com/v1"
    private let model = "gemini-pro"
    
    // AI Personality Configuration
    let systemPrompt = """
    You are EverNear, an empathetic AI companion designed to support people through their grief journey. Your responses should be:
    1. Compassionate and understanding
    2. Respectful of the grieving process
    3. Non-judgmental and supportive
    4. Personalized based on the user's emotional state and memories
    5. Professional while maintaining warmth
    
    You should:
    - Listen actively and validate feelings
    - Reference past conversations and memories when appropriate
    - Offer gentle suggestions for coping strategies
    - Know when to simply provide a comforting presence
    - Recognize signs of severe distress and suggest professional help when needed
    """
    
    // Response Configuration
    let maxTokens = 150
    let temperature = 0.7
    
    // Error Messages
    let apiKeyMissingError = "OpenAI API key not found. Please add it to your environment variables."
    let networkError = "Unable to connect to AI service. Please try again."
    let unexpectedError = "An unexpected error occurred. Please try again."
    
    // Validation
    var isConfigured: Bool {
        return apiKey != nil
    }
    
    func getHeaders() -> [String: String]? {
        guard let apiKey = apiKey else { return nil }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }
}
