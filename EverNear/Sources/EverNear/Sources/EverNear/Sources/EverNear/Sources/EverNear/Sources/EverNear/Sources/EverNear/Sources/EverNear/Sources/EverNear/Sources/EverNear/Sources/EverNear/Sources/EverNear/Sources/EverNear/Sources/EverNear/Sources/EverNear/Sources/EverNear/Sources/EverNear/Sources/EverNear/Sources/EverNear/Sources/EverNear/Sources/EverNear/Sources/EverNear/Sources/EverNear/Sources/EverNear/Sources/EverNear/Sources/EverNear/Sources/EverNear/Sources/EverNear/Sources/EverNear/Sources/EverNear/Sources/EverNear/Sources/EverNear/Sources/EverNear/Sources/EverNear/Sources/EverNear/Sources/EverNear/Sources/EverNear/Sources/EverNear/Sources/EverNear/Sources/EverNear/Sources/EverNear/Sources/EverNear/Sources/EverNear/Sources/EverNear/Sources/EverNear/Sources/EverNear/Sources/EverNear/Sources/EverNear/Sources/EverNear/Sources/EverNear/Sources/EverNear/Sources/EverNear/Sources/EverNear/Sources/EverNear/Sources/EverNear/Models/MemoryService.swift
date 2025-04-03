import UIKit
import AVFoundation

class MemoryService {
    // Singleton instance
    static let shared = MemoryService()
    
    // Private initializer for singleton
    private init() {}
    
    // MARK: - Memory Management
    
    func createMemory(title: String, content: String, category: MemoryCategory, images: [UIImage] = [], audioURL: URL? = nil, location: String? = nil, mood: String? = nil, isPrivate: Bool = true) -> Memory {
        // Save images if provided
        var imageFilenames: [String] = []
        for (index, image) in images.enumerated() {
            let filename = "\(UUID().uuidString)_\(index).jpg"
            if DataManager.shared.saveImage(image, withName: filename) {
                imageFilenames.append(filename)
            }
        }
        
        // Handle audio if provided
        var audioFilename: String? = nil
        if let audioURL = audioURL {
            audioFilename = "\(UUID().uuidString).m4a"
            let destinationURL = DataManager.shared.getAudioFileURL(withName: audioFilename!)
            
            do {
                try FileManager.default.copyItem(at: audioURL, to: destinationURL)
            } catch {
                print("Error copying audio file: \(error)")
                audioFilename = nil
            }
        }
        
        // Create and save memory
        let memory = Memory(
            title: title,
            content: content,
            category: category,
            imageFilenames: imageFilenames,
            audioFilename: audioFilename,
            location: location,
            mood: mood,
            isPrivate: isPrivate
        )
        
        DataManager.shared.saveMemory(memory)
        return memory
    }
    
    func updateMemory(_ memory: Memory, title: String? = nil, content: String? = nil, category: MemoryCategory? = nil, newImages: [UIImage]? = nil, removeImageIndices: [Int]? = nil, newAudioURL: URL? = nil, removeAudio: Bool = false, location: String? = nil, mood: String? = nil, isPrivate: Bool? = nil) -> Memory {
        var updatedMemory = memory
        
        // Update basic properties if provided
        if let title = title {
            updatedMemory.title = title
        }
        
        if let content = content {
            updatedMemory.content = content
        }
        
        if let category = category {
            updatedMemory.category = category
        }
        
        if let location = location {
            updatedMemory.location = location
        }
        
        if let mood = mood {
            updatedMemory.mood = mood
        }
        
        if let isPrivate = isPrivate {
            updatedMemory.isPrivate = isPrivate
        }
        
        // Handle image removals if specified
        if let removeImageIndices = removeImageIndices, !removeImageIndices.isEmpty {
            var filesToRemove: [String] = []
            
            for index in removeImageIndices.sorted(by: >) where index < updatedMemory.imageFilenames.count {
                let filename = updatedMemory.imageFilenames.remove(at: index)
                filesToRemove.append(filename)
            }
            
            // Delete the removed image files
            for filename in filesToRemove {
                _ = DataManager.shared.deleteImage(withName: filename)
            }
        }
        
        // Handle new images if provided
        if let newImages = newImages, !newImages.isEmpty {
            for (index, image) in newImages.enumerated() {
                let filename = "\(UUID().uuidString)_\(index).jpg"
                if DataManager.shared.saveImage(image, withName: filename) {
                    updatedMemory.imageFilenames.append(filename)
                }
            }
        }
        
        // Handle audio removal if specified
        if removeAudio, let audioFilename = updatedMemory.audioFilename {
            _ = DataManager.shared.deleteAudio(withName: audioFilename)
            updatedMemory.audioFilename = nil
        }
        
        // Handle new audio if provided
        if let newAudioURL = newAudioURL {
            // Remove old audio if it exists
            if let oldAudioFilename = updatedMemory.audioFilename {
                _ = DataManager.shared.deleteAudio(withName: oldAudioFilename)
            }
            
            // Save new audio
            let audioFilename = "\(UUID().uuidString).m4a"
            let destinationURL = DataManager.shared.getAudioFileURL(withName: audioFilename)
            
            do {
                try FileManager.default.copyItem(at: newAudioURL, to: destinationURL)
                updatedMemory.audioFilename = audioFilename
            } catch {
                print("Error copying audio file: \(error)")
            }
        }
        
        // Save updated memory
        DataManager.shared.saveMemory(updatedMemory)
        return updatedMemory
    }
    
    func deleteMemory(_ memory: Memory) {
        // Delete associated images
        for filename in memory.imageFilenames {
            _ = DataManager.shared.deleteImage(withName: filename)
        }
        
        // Delete associated audio
        if let audioFilename = memory.audioFilename {
            _ = DataManager.shared.deleteAudio(withName: audioFilename)
        }
        
        // Delete the memory itself
        DataManager.shared.deleteMemory(withId: memory.id)
    }
    
    // MARK: - Memory Retrieval
    
    func getAllMemories(sortedBy sortOrder: MemorySortOrder = .dateDescending) -> [Memory] {
        return DataManager.shared.getMemories(sortedBy: sortOrder)
    }
    
    func getMemoriesByCategory(_ category: MemoryCategory, sortedBy sortOrder: MemorySortOrder = .dateDescending) -> [Memory] {
        return DataManager.shared.getMemories(forCategory: category, sortedBy: sortOrder)
    }
    
    func searchMemories(query: String, sortedBy sortOrder: MemorySortOrder = .dateDescending) -> [Memory] {
        let allMemories = DataManager.shared.getMemories(sortedBy: sortOrder)
        let lowercasedQuery = query.lowercased()
        
        return allMemories.filter { memory in
            memory.title.lowercased().contains(lowercasedQuery) ||
            memory.content.lowercased().contains(lowercasedQuery) ||
            (memory.location?.lowercased().contains(lowercasedQuery) ?? false) ||
            (memory.mood?.lowercased().contains(lowercasedQuery) ?? false)
        }
    }
    
    func getRecentMemories(limit: Int = 5) -> [Memory] {
        let allMemories = DataManager.shared.getMemories(sortedBy: .dateDescending)
        return Array(allMemories.prefix(limit))
    }
    
    // MARK: - Memory Sharing
    
    func shareMemory(_ memory: Memory, completion: @escaping (URL?) -> Void) {
        // In a real app, this would generate a shareable link or file
        // For demo purposes, we'll just create a text representation
        
        var memoryText = "Memory: \(memory.title)\n\n"
        memoryText += "Category: \(memory.category.rawValue)\n"
        memoryText += "Date: \(formatDate(memory.date))\n\n"
        memoryText += memory.content
        
        if let location = memory.location {
            memoryText += "\n\nLocation: \(location)"
        }
        
        if let mood = memory.mood {
            memoryText += "\n\nMood: \(mood)"
        }
        
        // Create a temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("\(memory.title).txt")
        
        do {
            try memoryText.write(to: fileURL, atomically: true, encoding: .utf8)
            completion(fileURL)
        } catch {
            print("Error creating shareable file: \(error)")
            completion(nil)
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
