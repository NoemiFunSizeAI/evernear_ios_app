import XCTest
@testable import EverNear

class MemoryServiceTests: XCTestCase {
    
    var memoryService: MemoryService!
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        memoryService = MemoryService.shared
        dataManager = DataManager.shared
        
        // Clear existing memories before each test
        let memories = dataManager.memories
        for memory in memories {
            memoryService.deleteMemory(memory)
        }
    }
    
    override func tearDown() {
        // Clear memories after tests
        let memories = dataManager.memories
        for memory in memories {
            memoryService.deleteMemory(memory)
        }
        
        super.tearDown()
    }
    
    func testCreateMemory() {
        // Given
        let title = "Test Memory"
        let content = "This is a test memory content"
        let category = MemoryCategory.magicalMoments
        
        // When
        let memory = memoryService.createMemory(title: title, content: content, category: category)
        
        // Then
        XCTAssertEqual(memory.title, title)
        XCTAssertEqual(memory.content, content)
        XCTAssertEqual(memory.category, category)
        XCTAssertTrue(memory.isPrivate)
        XCTAssertEqual(memory.imageFilenames.count, 0)
        XCTAssertNil(memory.audioFilename)
        
        // Verify memory was saved to data manager
        let savedMemory = dataManager.getMemory(withId: memory.id)
        XCTAssertNotNil(savedMemory)
        XCTAssertEqual(savedMemory?.title, title)
    }
    
    func testUpdateMemory() {
        // Given
        let memory = memoryService.createMemory(
            title: "Original Title",
            content: "Original content",
            category: .magicalMoments
        )
        
        // When
        let updatedMemory = memoryService.updateMemory(
            memory,
            title: "Updated Title",
            content: "Updated content",
            category: .heartfeltFeelings
        )
        
        // Then
        XCTAssertEqual(updatedMemory.id, memory.id)
        XCTAssertEqual(updatedMemory.title, "Updated Title")
        XCTAssertEqual(updatedMemory.content, "Updated content")
        XCTAssertEqual(updatedMemory.category, .heartfeltFeelings)
        
        // Verify memory was updated in data manager
        let savedMemory = dataManager.getMemory(withId: memory.id)
        XCTAssertNotNil(savedMemory)
        XCTAssertEqual(savedMemory?.title, "Updated Title")
    }
    
    func testDeleteMemory() {
        // Given
        let memory = memoryService.createMemory(
            title: "Memory to Delete",
            content: "This memory will be deleted",
            category: .magicalMoments
        )
        
        // Verify memory exists
        XCTAssertNotNil(dataManager.getMemory(withId: memory.id))
        
        // When
        memoryService.deleteMemory(memory)
        
        // Then
        XCTAssertNil(dataManager.getMemory(withId: memory.id))
    }
    
    func testGetMemoriesByCategory() {
        // Given
        memoryService.createMemory(title: "Memory 1", content: "Content 1", category: .magicalMoments)
        memoryService.createMemory(title: "Memory 2", content: "Content 2", category: .heartfeltFeelings)
        memoryService.createMemory(title: "Memory 3", content: "Content 3", category: .magicalMoments)
        
        // When
        let magicalMemories = memoryService.getMemoriesByCategory(.magicalMoments)
        let heartfeltMemories = memoryService.getMemoriesByCategory(.heartfeltFeelings)
        
        // Then
        XCTAssertEqual(magicalMemories.count, 2)
        XCTAssertEqual(heartfeltMemories.count, 1)
    }
    
    func testSearchMemories() {
        // Given
        memoryService.createMemory(title: "Birthday Party", content: "We celebrated with cake", category: .magicalMoments)
        memoryService.createMemory(title: "Vacation", content: "We went to the beach", category: .magicalMoments)
        memoryService.createMemory(title: "Sad Day", content: "I miss them so much", category: .heartfeltFeelings)
        
        // When
        let birthdayResults = memoryService.searchMemories(query: "birthday")
        let beachResults = memoryService.searchMemories(query: "beach")
        let missResults = memoryService.searchMemories(query: "miss")
        let noResults = memoryService.searchMemories(query: "nonexistent")
        
        // Then
        XCTAssertEqual(birthdayResults.count, 1)
        XCTAssertEqual(beachResults.count, 1)
        XCTAssertEqual(missResults.count, 1)
        XCTAssertEqual(noResults.count, 0)
    }
    
    func testGetRecentMemories() {
        // Given
        for i in 1...10 {
            memoryService.createMemory(
                title: "Memory \(i)",
                content: "Content \(i)",
                category: .magicalMoments
            )
        }
        
        // When
        let recentMemories = memoryService.getRecentMemories(limit: 5)
        
        // Then
        XCTAssertEqual(recentMemories.count, 5)
        XCTAssertEqual(recentMemories[0].title, "Memory 10")
        XCTAssertEqual(recentMemories[4].title, "Memory 6")
    }
}
