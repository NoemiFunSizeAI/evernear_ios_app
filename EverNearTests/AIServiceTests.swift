import XCTest
@testable import EverNear

class AIServiceTests: XCTestCase {
    var aiService: AIService!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        aiService = AIService.shared
        expectation = expectation(description: "AI Response")
    }
    
    func testAIServiceConfiguration() {
        XCTAssertTrue(AIConfig.shared.isConfigured, "API Key should be configured. Make sure OPENAI_API_KEY environment variable is set.")
    }
    
    func testBasicResponse() {
        let testMessage = "I really miss my grandmother. She passed away last month."
        let context: [Message] = []
        
        aiService.generateResponse(to: testMessage, context: context) { result in
            switch result {
            case .success(let response):
                // Verify response is not empty
                XCTAssertFalse(response.isEmpty)
                
                // Verify response contains empathetic content
                let empathyKeywords = ["sorry", "loss", "understand", "difficult", "here", "support"]
                let containsEmpathy = empathyKeywords.contains { response.lowercased().contains($0) }
                XCTAssertTrue(containsEmpathy, "Response should contain empathetic language")
                
                // Verify response length is reasonable
                XCTAssertTrue(response.count > 20, "Response should be meaningful in length")
                XCTAssertTrue(response.count < 500, "Response should not be too verbose")
                
            case .failure(let error):
                XCTFail("AI Service failed with error: \(error)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testContextualResponse() {
        let context: [Message] = [
            Message(content: "My grandmother loved gardening.", isUser: true),
            Message(content: "That's a beautiful memory. What was her favorite flower to grow?", isUser: false)
        ]
        
        let testMessage = "She loved roses, especially yellow ones."
        
        aiService.generateResponse(to: testMessage, context: context) { result in
            switch result {
            case .success(let response):
                // Verify context awareness
                let contextKeywords = ["garden", "rose", "yellow", "flower"]
                let isContextAware = contextKeywords.contains { response.lowercased().contains($0) }
                XCTAssertTrue(isContextAware, "Response should reference conversation context")
                
            case .failure(let error):
                XCTFail("AI Service failed with error: \(error)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testErrorHandling() {
        // Temporarily clear API key to test error handling
        let originalAPIKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
        setenv("OPENAI_API_KEY", "", 1)
        
        aiService.generateResponse(to: "Test message", context: []) { result in
            switch result {
            case .success:
                XCTFail("Should fail without API key")
            case .failure(let error):
                XCTAssertEqual(error, .apiKeyMissing)
            }
            
            // Restore API key
            if let key = originalAPIKey {
                setenv("OPENAI_API_KEY", key, 1)
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
