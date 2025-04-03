import Foundation

class DataManager {
    // Singleton instance
    static let shared = DataManager()
    
    // Private initializer for singleton
    private init() {
        loadUserProfile()
        loadMemories()
        loadConversations()
        loadReflections()
    }
    
    // MARK: - Properties
    
    private(set) var userProfile: UserProfile?
    private(set) var memories: [Memory] = []
    private(set) var conversations: [Conversation] = []
    private(set) var reflections: [Reflection] = []
    
    // MARK: - File Paths
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var userProfileURL: URL {
        documentsDirectory.appendingPathComponent("userProfile.json")
    }
    
    private var memoriesURL: URL {
        documentsDirectory.appendingPathComponent("memories.json")
    }
    
    private var conversationsURL: URL {
        documentsDirectory.appendingPathComponent("conversations.json")
    }
    
    private var reflectionsURL: URL {
        documentsDirectory.appendingPathComponent("reflections.json")
    }
    
    // MARK: - User Profile Methods
    
    func saveUserProfile(_ profile: UserProfile) {
        userProfile = profile
        
        do {
            let data = try JSONEncoder().encode(profile)
            try data.write(to: userProfileURL)
        } catch {
            print("Error saving user profile: \(error)")
        }
    }
    
    private func loadUserProfile() {
        do {
            if FileManager.default.fileExists(atPath: userProfileURL.path) {
                let data = try Data(contentsOf: userProfileURL)
                userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
            }
        } catch {
            print("Error loading user profile: \(error)")
        }
    }
    
    // MARK: - Memory Methods
    
    func saveMemory(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index] = memory
        } else {
            memories.append(memory)
        }
        
        saveMemories()
    }
    
    func deleteMemory(withId id: String) {
        memories.removeAll { $0.id == id }
        saveMemories()
    }
    
    func getMemory(withId id: String) -> Memory? {
        return memories.first { $0.id == id }
    }
    
    func getMemories(forCategory category: MemoryCategory? = nil, sortedBy sortOrder: MemorySortOrder = .dateDescending) -> [Memory] {
        var filteredMemories = memories
        
        if let category = category {
            filteredMemories = filteredMemories.filter { $0.category == category }
        }
        
        switch sortOrder {
        case .dateAscending:
            return filteredMemories.sorted { $0.date < $1.date }
        case .dateDescending:
            return filteredMemories.sorted { $0.date > $1.date }
        case .titleAscending:
            return filteredMemories.sorted { $0.title < $1.title }
        }
    }
    
    private func saveMemories() {
        do {
            let data = try JSONEncoder().encode(memories)
            try data.write(to: memoriesURL)
        } catch {
            print("Error saving memories: \(error)")
        }
    }
    
    private func loadMemories() {
        do {
            if FileManager.default.fileExists(atPath: memoriesURL.path) {
                let data = try Data(contentsOf: memoriesURL)
                memories = try JSONDecoder().decode([Memory].self, from: data)
            }
        } catch {
            print("Error loading memories: \(error)")
        }
    }
    
    // MARK: - Conversation Methods
    
    func saveConversation(_ conversation: Conversation) {
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversation
        } else {
            conversations.append(conversation)
        }
        
        saveConversations()
    }
    
    func deleteConversation(withId id: String) {
        conversations.removeAll { $0.id == id }
        saveConversations()
    }
    
    func getConversation(withId id: String) -> Conversation? {
        return conversations.first { $0.id == id }
    }
    
    func getConversations(sortedBy sortOrder: ConversationSortOrder = .dateDescending) -> [Conversation] {
        switch sortOrder {
        case .dateAscending:
            return conversations.sorted { $0.date < $1.date }
        case .dateDescending:
            return conversations.sorted { $0.date > $1.date }
        }
    }
    
    private func saveConversations() {
        do {
            let data = try JSONEncoder().encode(conversations)
            try data.write(to: conversationsURL)
        } catch {
            print("Error saving conversations: \(error)")
        }
    }
    
    private func loadConversations() {
        do {
            if FileManager.default.fileExists(atPath: conversationsURL.path) {
                let data = try Data(contentsOf: conversationsURL)
                conversations = try JSONDecoder().decode([Conversation].self, from: data)
            }
        } catch {
            print("Error loading conversations: \(error)")
        }
    }
    
    // MARK: - Reflection Methods
    
    func saveReflection(_ reflection: Reflection) {
        if let index = reflections.firstIndex(where: { $0.id == reflection.id }) {
            reflections[index] = reflection
        } else {
            reflections.append(reflection)
        }
        
        saveReflections()
    }
    
    func getReflectionForToday() -> Reflection? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return reflections.first { calendar.isDate($0.date, inSameDayAs: today) }
    }
    
    func getRandomReflection(excluding id: String? = nil) -> Reflection? {
        let filteredReflections = id != nil ? reflections.filter { $0.id != id } : reflections
        guard !filteredReflections.isEmpty else { return nil }
        
        let randomIndex = Int.random(in: 0..<filteredReflections.count)
        return filteredReflections[randomIndex]
    }
    
    private func saveReflections() {
        do {
            let data = try JSONEncoder().encode(reflections)
            try data.write(to: reflectionsURL)
        } catch {
            print("Error saving reflections: \(error)")
        }
    }
    
    private func loadReflections() {
        do {
            if FileManager.default.fileExists(atPath: reflectionsURL.path) {
                let data = try Data(contentsOf: reflectionsURL)
                reflections = try JSONDecoder().decode([Reflection].self, from: data)
            } else {
                // If no reflections exist, create default ones
                createDefaultReflections()
            }
        } catch {
            print("Error loading reflections: \(error)")
        }
    }
    
    private func createDefaultReflections() {
        let defaultReflections = [
            "Memories are a way to hold onto the things you love, the things you are, the things you never want to lose.",
            "Grief is the price we pay for love.",
            "What we have once enjoyed we can never lose; all that we love deeply becomes a part of us.",
            "The pain of grief is just as much a part of life as the joy of love; it is, perhaps, the price we pay for love.",
            "Sometimes, only one person is missing, and the whole world seems depopulated.",
            "Grief is like the ocean; it comes in waves, ebbing and flowing. Sometimes the water is calm, and sometimes it is overwhelming.",
            "Those we love don't go away, they walk beside us every day.",
            "The reality is that you will grieve forever. You will not 'get over' the loss of a loved one; you will learn to live with it.",
            "When someone you love becomes a memory, the memory becomes a treasure.",
            "Grief is not a sign of weakness, nor a lack of faith. It is the price of love."
        ]
        
        for content in defaultReflections {
            let reflection = Reflection(content: content)
            reflections.append(reflection)
        }
        
        saveReflections()
    }
    
    // MARK: - Image Methods
    
    func saveImage(_ image: UIImage, withName filename: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return false }
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("Error saving image: \(error)")
            return false
        }
    }
    
    func loadImage(withName filename: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
    
    func deleteImage(withName filename: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            print("Error deleting image: \(error)")
            return false
        }
    }
    
    // MARK: - Audio Methods
    
    func getAudioFileURL(withName filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
    
    func deleteAudio(withName filename: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            print("Error deleting audio: \(error)")
            return false
        }
    }
}

// MARK: - Enums

enum MemorySortOrder {
    case dateAscending
    case dateDescending
    case titleAscending
}

enum ConversationSortOrder {
    case dateAscending
    case dateDescending
}

// MARK: - UIKit Import

import UIKit
