import XCTest
@testable import EverNear

class EmotionalResponseAnalyzerTests: XCTestCase {
    
    var analyzer: EmotionalResponseAnalyzer!
    
    override func setUp() {
        super.setUp()
        analyzer = EmotionalResponseAnalyzer.shared
    }
    
    func testAnalyzeEmotionGrief() {
        // Given
        let text = "I'm really struggling with grief today. I miss them so much."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .grief)
        XCTAssertTrue(result.detectedEmotions[.grief] ?? 0 > 0)
        XCTAssertEqual(result.sentimentCategory, .negative)
    }
    
    func testAnalyzeEmotionSadness() {
        // Given
        let text = "I feel so sad and down today. It's hard to keep going."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .sadness)
        XCTAssertTrue(result.detectedEmotions[.sadness] ?? 0 > 0)
        XCTAssertEqual(result.sentimentCategory, .negative)
    }
    
    func testAnalyzeEmotionAnger() {
        // Given
        let text = "I'm so angry that this happened. It's not fair."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .anger)
        XCTAssertTrue(result.detectedEmotions[.anger] ?? 0 > 0)
        XCTAssertEqual(result.sentimentCategory, .negative)
    }
    
    func testAnalyzeEmotionFear() {
        // Given
        let text = "I'm afraid of what the future holds without them."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .fear)
        XCTAssertTrue(result.detectedEmotions[.fear] ?? 0 > 0)
        XCTAssertEqual(result.sentimentCategory, .negative)
    }
    
    func testAnalyzeEmotionAnxiety() {
        // Given
        let text = "I'm feeling so anxious and worried about how to handle the holidays."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .anxiety)
        XCTAssertTrue(result.detectedEmotions[.anxiety] ?? 0 > 0)
        XCTAssertEqual(result.sentimentCategory, .negative)
    }
    
    func testAnalyzeEmotionJoy() {
        // Given
        let text = "I found a photo that made me happy today. It brought back good memories."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .joy)
        XCTAssertTrue(result.detectedEmotions[.joy] ?? 0 > 0)
        XCTAssertEqual(result.sentimentCategory, .positive)
    }
    
    func testAnalyzeEmotionGratitude() {
        // Given
        let text = "I'm so grateful for the time we had together. I appreciate all the memories."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .gratitude)
        XCTAssertTrue(result.detectedEmotions[.gratitude] ?? 0 > 0)
        XCTAssertEqual(result.sentimentCategory, .positive)
    }
    
    func testAnalyzeEmotionNostalgia() {
        // Given
        let text = "I remember when we used to go to the beach every summer. Those were such good times."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .nostalgia)
        XCTAssertTrue(result.detectedEmotions[.nostalgia] ?? 0 > 0)
    }
    
    func testAnalyzeEmotionConfusion() {
        // Given
        let text = "I'm not sure how to feel. I'm confused about what to do next."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .confusion)
        XCTAssertTrue(result.detectedEmotions[.confusion] ?? 0 > 0)
    }
    
    func testAnalyzeEmotionNeutral() {
        // Given
        let text = "I'm just checking in today."
        
        // When
        let result = analyzer.analyzeEmotion(in: text)
        
        // Then
        XCTAssertEqual(result.dominantEmotion, .neutral)
        XCTAssertEqual(result.sentimentCategory, .neutral)
    }
    
    func testSuggestResponse() {
        // Test response suggestions for different emotions
        testResponseSuggestion(for: .grief)
        testResponseSuggestion(for: .sadness)
        testResponseSuggestion(for: .anger)
        testResponseSuggestion(for: .fear)
        testResponseSuggestion(for: .anxiety)
        testResponseSuggestion(for: .joy)
        testResponseSuggestion(for: .gratitude)
        testResponseSuggestion(for: .nostalgia)
        testResponseSuggestion(for: .confusion)
        testResponseSuggestion(for: .neutral)
    }
    
    private func testResponseSuggestion(for emotion: Emotion) {
        // Given
        let analysisResult = EmotionAnalysisResult(
            dominantEmotion: emotion,
            detectedEmotions: [emotion: 0.8],
            sentimentScore: emotion == .joy || emotion == .gratitude ? 0.5 : -0.5,
            sentimentCategory: emotion == .joy || emotion == .gratitude ? .positive : .negative
        )
        
        // When
        let response = analyzer.suggestResponse(for: analysisResult)
        
        // Then
        XCTAssertFalse(response.isEmpty)
    }
}
