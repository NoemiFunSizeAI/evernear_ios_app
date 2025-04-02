import Foundation

// Memory categories
enum MemoryCategory: String, CaseIterable, Codable {
    case magicalMoments = "Magical Moments"
    case heartfeltFeelings = "Heartfelt Feelings"
    case lifeUpdates = "Life Updates"
    case difficultTimes = "Difficult Times"
    case sharedWins = "Shared Wins"
    
    var icon: String {
        switch self {
        case .magicalMoments: return "✨"
        case .heartfeltFeelings: return "❤️"
        case .lifeUpdates: return "📝"
        case .difficultTimes: return "🌧️"
        case .sharedWins: return "🏆"
        }
    }
}

// Memory model
struct Memory: Codable, Identifiable {
    var id: String
    var title: String
    var content: String
    var category: MemoryCategory
    var date: Date
    var imageFilenames: [String]
    var audioFilename: String?
    var location: String?
    var mood: String?
    var isPrivate: Bool
    
    init(id: String = UUID().uuidString,
         title: String,
         content: String,
         category: MemoryCategory,
         date: Date = Date(),
         imageFilenames: [String] = [],
         audioFilename: String? = nil,
         location: String? = nil,
         mood: String? = nil,
         isPrivate: Bool = true) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.date = date
        self.imageFilenames = imageFilenames
        self.audioFilename = audioFilename
        self.location = location
        self.mood = mood
        self.isPrivate = isPrivate
    }
}

// User profile model
struct UserProfile: Codable {
    var name: String
    var lovedOneName: String
    var relationship: String
    var profileImageFilename: String?
    var notificationPreferences: NotificationPreferences
    var privacySettings: PrivacySettings
    
    init(name: String,
         lovedOneName: String,
         relationship: String,
         profileImageFilename: String? = nil,
         notificationPreferences: NotificationPreferences = NotificationPreferences(),
         privacySettings: PrivacySettings = PrivacySettings()) {
        self.name = name
        self.lovedOneName = lovedOneName
        self.relationship = relationship
        self.profileImageFilename = profileImageFilename
        self.notificationPreferences = notificationPreferences
        self.privacySettings = privacySettings
    }
}

// Notification preferences model
struct NotificationPreferences: Codable {
    var enableDailyReminders: Bool
    var reminderTime: Date
    var enableMemoryAnniversaries: Bool
    var enableCompanionMessages: Bool
    
    init(enableDailyReminders: Bool = true,
         reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 10, minute: 0)) ?? Date(),
         enableMemoryAnniversaries: Bool = true,
         enableCompanionMessages: Bool = true) {
        self.enableDailyReminders = enableDailyReminders
        self.reminderTime = reminderTime
        self.enableMemoryAnniversaries = enableMemoryAnniversaries
        self.enableCompanionMessages = enableCompanionMessages
    }
}

// Privacy settings model
struct PrivacySettings: Codable {
    var enableCloudBackup: Bool
    var enableDataCollection: Bool
    var sharedContactIds: [String]
    
    init(enableCloudBackup: Bool = true,
         enableDataCollection: Bool = false,
         sharedContactIds: [String] = []) {
        self.enableCloudBackup = enableCloudBackup
        self.enableDataCollection = enableDataCollection
        self.sharedContactIds = sharedContactIds
    }
}

// Message model for AI companion
struct Message: Codable, Identifiable {
    var id: String
    var content: String
    var isUser: Bool
    var date: Date
    var attachedMemoryId: String?
    
    init(id: String = UUID().uuidString,
         content: String,
         isUser: Bool,
         date: Date = Date(),
         attachedMemoryId: String? = nil) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.date = date
        self.attachedMemoryId = attachedMemoryId
    }
}

// Conversation model for AI companion
struct Conversation: Codable, Identifiable {
    var id: String
    var messages: [Message]
    var date: Date
    var title: String
    
    init(id: String = UUID().uuidString,
         messages: [Message] = [],
         date: Date = Date(),
         title: String = "New Conversation") {
        self.id = id
        self.messages = messages
        self.date = date
        self.title = title
    }
}

// Reflection model for daily reflections
struct Reflection: Codable, Identifiable {
    var id: String
    var content: String
    var date: Date
    var isCustom: Bool
    
    init(id: String = UUID().uuidString,
         content: String,
         date: Date = Date(),
         isCustom: Bool = false) {
        self.id = id
        self.content = content
        self.date = date
        self.isCustom = isCustom
    }
}
