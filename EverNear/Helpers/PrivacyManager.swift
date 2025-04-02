import UIKit
import LocalAuthentication

class PrivacyManager {
    // Singleton instance
    static let shared = PrivacyManager()
    
    // Private initializer for singleton
    private init() {
        loadPrivacySettings()
    }
    
    // MARK: - Properties
    
    private(set) var privacySettings: PrivacySettings = PrivacySettings()
    private let securityManager = SecurityManager.shared
    
    // MARK: - Authentication
    
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        if privacySettings.requireBiometricAuth {
            securityManager.setupBiometricAuthentication(completion: completion)
        } else {
            // If biometric auth is not required, authentication is successful by default
            completion(true, nil)
        }
    }
    
    func lockApp() {
        UserDefaults.standard.set(true, forKey: "appLocked")
    }
    
    func unlockApp() {
        UserDefaults.standard.set(false, forKey: "appLocked")
    }
    
    func isAppLocked() -> Bool {
        return UserDefaults.standard.bool(forKey: "appLocked")
    }
    
    // MARK: - Privacy Settings
    
    func updatePrivacySettings(_ settings: PrivacySettings) {
        privacySettings = settings
        savePrivacySettings()
    }
    
    func toggleBiometricAuth(_ enable: Bool) {
        privacySettings.requireBiometricAuth = enable
        savePrivacySettings()
    }
    
    func toggleScreenshotProtection(_ enable: Bool) {
        privacySettings.preventScreenshots = enable
        securityManager.enableScreenshotProtection(enable)
        savePrivacySettings()
    }
    
    func toggleDataCollection(_ enable: Bool) {
        privacySettings.allowDataCollection = enable
        savePrivacySettings()
    }
    
    func toggleCloudBackup(_ enable: Bool) {
        privacySettings.enableCloudBackup = enable
        savePrivacySettings()
    }
    
    func toggleAutoLock(_ enable: Bool) {
        privacySettings.enableAutoLock = enable
        savePrivacySettings()
    }
    
    func setAutoLockTime(_ minutes: Int) {
        privacySettings.autoLockTime = minutes
        savePrivacySettings()
    }
    
    // MARK: - Data Sharing
    
    func addSharedContact(_ contactId: String) {
        if !privacySettings.sharedContactIds.contains(contactId) {
            privacySettings.sharedContactIds.append(contactId)
            savePrivacySettings()
        }
    }
    
    func removeSharedContact(_ contactId: String) {
        privacySettings.sharedContactIds.removeAll { $0 == contactId }
        savePrivacySettings()
    }
    
    func canShareWithContact(_ contactId: String) -> Bool {
        return privacySettings.sharedContactIds.contains(contactId)
    }
    
    // MARK: - Data Protection
    
    func encryptMemory(_ memory: Memory) -> Data? {
        do {
            let data = try JSONEncoder().encode(memory)
            return securityManager.encryptData(data, withKey: "EverNearMemoryEncryptionKey")
        } catch {
            print("Error encrypting memory: \(error)")
            return nil
        }
    }
    
    func decryptMemory(from data: Data) -> Memory? {
        guard let decryptedData = securityManager.decryptData(data, withKey: "EverNearMemoryEncryptionKey") else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(Memory.self, from: decryptedData)
        } catch {
            print("Error decrypting memory: \(error)")
            return nil
        }
    }
    
    // MARK: - Data Export
    
    func exportMemories(completion: @escaping (URL?) -> Void) {
        let memories = DataManager.shared.memories
        
        do {
            // Create a JSON representation of memories
            let data = try JSONEncoder().encode(memories)
            
            // Create a temporary file
            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("EverNear_Memories_Export.json")
            
            // Write data to file
            try data.write(to: fileURL)
            
            completion(fileURL)
        } catch {
            print("Error exporting memories: \(error)")
            completion(nil)
        }
    }
    
    // MARK: - Data Deletion
    
    func deleteAllUserData(completion: @escaping (Bool) -> Void) {
        // Delete all memories
        let memories = DataManager.shared.memories
        for memory in memories {
            MemoryService.shared.deleteMemory(memory)
        }
        
        // Delete all conversations
        let conversations = DataManager.shared.conversations
        for conversation in conversations {
            DataManager.shared.deleteConversation(withId: conversation.id)
        }
        
        // Reset user profile
        DataManager.shared.saveUserProfile(UserProfile(name: "", lovedOneName: "", relationship: ""))
        
        // Reset privacy settings
        updatePrivacySettings(PrivacySettings())
        
        // Reset user defaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        completion(true)
    }
    
    // MARK: - Persistence
    
    private func savePrivacySettings() {
        do {
            let data = try JSONEncoder().encode(privacySettings)
            securityManager.secureUserDefaults(key: "privacySettings", value: data)
        } catch {
            print("Error saving privacy settings: \(error)")
        }
    }
    
    private func loadPrivacySettings() {
        if let data = securityManager.retrieveSecureUserDefaults(key: "privacySettings") as? Data {
            do {
                privacySettings = try JSONDecoder().decode(PrivacySettings.self, from: data)
            } catch {
                print("Error loading privacy settings: \(error)")
                privacySettings = PrivacySettings()
            }
        } else {
            privacySettings = PrivacySettings()
        }
    }
}

// MARK: - Extended Privacy Settings

extension PrivacySettings {
    // Additional privacy settings not in the base model
    var requireBiometricAuth: Bool {
        get { return UserDefaults.standard.bool(forKey: "requireBiometricAuth") }
        set { UserDefaults.standard.set(newValue, forKey: "requireBiometricAuth") }
    }
    
    var preventScreenshots: Bool {
        get { return UserDefaults.standard.bool(forKey: "preventScreenshots") }
        set { UserDefaults.standard.set(newValue, forKey: "preventScreenshots") }
    }
    
    var enableAutoLock: Bool {
        get { return UserDefaults.standard.bool(forKey: "enableAutoLock") }
        set { UserDefaults.standard.set(newValue, forKey: "enableAutoLock") }
    }
    
    var autoLockTime: Int {
        get { return UserDefaults.standard.integer(forKey: "autoLockTime") }
        set { UserDefaults.standard.set(newValue, forKey: "autoLockTime") }
    }
    
    var allowDataCollection: Bool {
        get { return UserDefaults.standard.bool(forKey: "allowDataCollection") }
        set { UserDefaults.standard.set(newValue, forKey: "allowDataCollection") }
    }
}
