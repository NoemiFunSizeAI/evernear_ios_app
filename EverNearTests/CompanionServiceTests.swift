import XCTest
@testable import EverNear

class CompanionServiceTests: XCTestCase {
    
    var companionService: CompanionService!
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        companionService = CompanionService.shared
        dataManager = DataManager.shared
        
        // Clear existing conversations before each test
        let conversations = dataManager.conversations
        for conversation in conversations {
            dataManager.deleteConversation(withId: conversation.id)
        }
    }
    
    override func tearDown() {
        // Clear conversations after tests
        let conversations = dataManager.conversations
        for conversation in conversations {
            dataManager.deleteConversation(withId: conversation.id)
        }
        
        super.tearDown()
    }
    
    func testStartNewConversation() {
        // When
        let conversation = companionService.startNewConversation()
        
        // Then
        XCTAssertNotNil(conversation)
        XCTAssertEqual(conversation.title, "New Conversation")
        XCTAssertEqual(conversation.messages.count, 0)
        
        // Verify conversation was saved to data manager
        let savedConversation = dataManager.getConversation(withId: conversation.id)
        XCTAssertNotNil(savedConversation)
    }
    
    func testGetCurrentConversation() {
        // When
        let conversation1 = companionService.getCurrentConversation()
        let conversation2 = companionService.getCurrentConversation()
        
        // Then
        XCTAssertEqual(conversation1.id, conversation2.id)
    }
    
    func testAddUserMessage() {
        // Given
        let content = "Hello, I'm feeling sad today"
        
        // When
        let message = companionService.addUserMessage(content)
        
        // Then
        XCTAssertEqual(message.content, content)
        XCTAssertTrue(message.isUser)
        
        // Verify message was added to current conversation
        let conversation = companionService.getCurrentConversation()
        XCTAssertEqual(conversation.messages.count, 1)
        XCTAssertEqual(conversation.messages[0].content, content)
        
        // Verify conversation title was updated
        XCTAssertEqual(conversation.title, "Hello, I'm feeling...")
    }
    
    func testGenerateCompanionResponse() {
        // Given
        let userMessage = "I'm feeling sad today"
        companionService.addUserMessage(userMessage)
        
        // When
        let expectation = self.expectation(description: "Generate companion response")
        
        companionService.generateCompanionResponse(to: userMessage) { message in
            // Then
            XCTAssertFalse(message.isUser)
            XCTAssertFalse(message.content.isEmpty)
            
            // Verify response was added to current conversation
            let conversation = self.companionService.getCurrentConversation()
            XCTAssertEqual(conversation.messages.count, 2)
            XCTAssertEqual(conversation.messages[1].content, message.content)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testResponseToEmotionalKeywords() {
        // Test responses to different emotional keywords
        testResponseToKeyword("I feel sad today", emotionCategory: "sadness")
        testResponseToKeyword("I'm so happy about the memories", emotionCategory: "happiness")
        testResponseToKeyword("I'm angry that they're gone", emotionCategory: "anger")
        testResponseToKeyword("I'm anxious about the future", emotionCategory: "anxiety")
        testResponseToKeyword("I remember when we used to go hiking", emotionCategory: "memories")
        testResponseToKeyword("How do I cope with this loss?", emotionCategory: "coping")
        testResponseToKeyword("Thank you for listening", emotionCategory: "gratitude")
        testResponseToKeyword("Hello there", emotionCategory: "greeting")
    }
    
    private func testResponseToKeyword(_ message: String, emotionCategory: String) {
        // When
        let expectation = self.expectation(description: "Generate response to \(emotionCategory)")
        
        companionService.generateCompanionResponse(to: message) { response in
            // Then
            XCTAssertFalse(response.content.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
