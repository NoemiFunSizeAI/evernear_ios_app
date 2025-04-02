import XCTest
@testable import EverNear

class MemoryAndSupportTests: XCTestCase {
    let memoryManager = MemoryManager.shared
    let checkInManager = CheckInManager.shared
    let supportManager = SupportNetworkManager.shared
    
    override func setUp() {
        super.setUp()
        // Add test data
        setupTestMemories()
        setupTestCheckIns()
        setupTestSupportNetwork()
    }
    
    private func setupTestMemories() {
        let testMemories = [
            Memory(
                id: UUID(),
                category: .magicalMoments,
                content: "We used to bake cookies every Sunday",
                date: Date(),
                emotionalState: EmotionalState(primaryEmotion: "love", intensity: 8, mixedEmotions: []),
                personName: "Mom",
                location: "Home",
                mediaUrls: nil
            ),
            Memory(
                id: UUID(),
                category: .difficultTimes,
                content: "Missing our morning coffee chats",
                date: Date(),
                emotionalState: EmotionalState(primaryEmotion: "deep_grief", intensity: 7, mixedEmotions: ["longing"]),
                personName: "Mom",
                location: "Kitchen",
                mediaUrls: nil
            )
        ]
        
        testMemories.forEach { memoryManager.addMemory($0) }
    }
    
    private func setupTestCheckIns() {
        let testCheckIns = [
            DailyCheckIn(
                date: Date(),
                emotionalState: EmotionalState(primaryEmotion: "hope", intensity: 6, mixedEmotions: []),
                activities: ["Looked at photos", "Went for a walk"],
                selfCareActions: ["Deep breathing", "Called friend"],
                notes: "Better day today",
                supportNeeded: false
            ),
            DailyCheckIn(
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                emotionalState: EmotionalState(primaryEmotion: "deep_grief", intensity: 8, mixedEmotions: ["anxiety"]),
                activities: ["Stayed in bed", "Cried"],
                selfCareActions: ["Hot shower"],
                notes: "Really missing them",
                supportNeeded: true
            )
        ]
        
        testCheckIns.forEach { checkInManager.recordCheckIn($0) }
    }
    
    private func setupTestSupportNetwork() {
        let testContacts = [
            SupportContact(
                name: "Jane Smith",
                relationship: "Friend",
                contactMethods: [.phone("555-0123")],
                availabilityHours: [9...21],
                specialties: nil
            )
        ]
        
        let testResources = [
            SupportResource(
                name: "24/7 Crisis Line",
                type: .crisis,
                description: "Immediate support available",
                contactInfo: "1-800-555-0000",
                availabilityHours: "24/7",
                website: URL(string: "https://example.com")
            )
        ]
        
        testContacts.forEach { supportManager.addTrustedContact($0) }
        testResources.forEach { supportManager.addProfessionalResource($0) }
    }
    
    func testMemoryRetrieval() {
        // Test relevant memory retrieval
        let memories = memoryManager.getRelevantMemories(forPerson: "Mom", emotion: "deep_grief")
        XCTAssertFalse(memories.isEmpty, "Should find relevant memories")
        XCTAssertEqual(memories.first?.category, .magicalMoments, "Should prioritize positive memories for deep grief")
    }
    
    func testMemoryPrompts() {
        let prompt = memoryManager.getMemoryPrompt(forEmotion: "deep_grief")
        XCTAssertFalse(prompt.isEmpty, "Should provide a memory prompt")
    }
    
    func testCheckInAnalysis() {
        let analysis = checkInManager.analyzeEmotionalPattern()
        XCTAssertFalse(analysis.isEmpty, "Should provide emotional pattern analysis")
    }
    
    func testSelfCareRecommendations() {
        let recommendation = checkInManager.getSelfCareRecommendation(forEmotion: "anxiety")
        XCTAssertFalse(recommendation.isEmpty, "Should provide self-care recommendation")
    }
    
    func testSupportRecommendations() {
        let recommendation = supportManager.getSupportRecommendation(forEmotion: "deep_grief", intensity: 9)
        XCTAssertTrue(recommendation.contains("crisis"), "Should recommend crisis support for high intensity")
    }
    
    func testAvailableContacts() {
        let resources = supportManager.getResources(ofType: .crisis)
        XCTAssertFalse(resources.isEmpty, "Should find crisis resources")
    }
}

// Run tests
let tests = MemoryAndSupportTests()
tests.setUp()
tests.testMemoryRetrieval()
tests.testMemoryPrompts()
tests.testCheckInAnalysis()
tests.testSelfCareRecommendations()
tests.testSupportRecommendations()
tests.testAvailableContacts()
print("All tests completed successfully")
