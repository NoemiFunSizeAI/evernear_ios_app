import SwiftUI

enum NavigationContext: Equatable {
    // Memory contexts
    case memories(category: MemoryCategory?)
    case memoryDetail(Memory)
    case memoryCreation(MemoryType)
    case memoryCollection(loved: LovedOne)
    
    // Journal contexts
    case journal(entry: JournalEntry?)
    case journalCalendar
    case journalMood
    case journalPrompts
    
    // Companion contexts
    case companion(mode: CompanionMode)
    case companionChat(conversation: Conversation?)
    case companionVoice(session: VoiceSession?)
    case companionInsights
    
    // Support contexts
    case supportNetwork
    case supportResources
    case supportGroups
    case supportProfessional
    
    // Profile contexts
    case profile(section: ProfileSection?)
    case profileSettings
    case profilePrivacy
    case profileNotifications
    
    // Home contexts
    case home
    case dailyCheck
    case insights
    case timeline
    
    var title: String {
        switch self {
        // Memory titles
        case .memories(let category):
            return category?.name ?? "Memories"
        case .memoryDetail:
            return "Memory"
        case .memoryCreation(let type):
            return "New \(type.name)"
        case .memoryCollection(let loved):
            return loved.name
            
        // Journal titles
        case .journal:
            return "Journal"
        case .journalCalendar:
            return "Calendar"
        case .journalMood:
            return "Mood Tracker"
        case .journalPrompts:
            return "Writing Prompts"
            
        // Companion titles
        case .companion(let mode):
            return mode.title
        case .companionChat:
            return "Chat"
        case .companionVoice:
            return "Voice Chat"
        case .companionInsights:
            return "AI Insights"
            
        // Support titles
        case .supportNetwork:
            return "Support Network"
        case .supportResources:
            return "Resources"
        case .supportGroups:
            return "Support Groups"
        case .supportProfessional:
            return "Professional Help"
            
        // Profile titles
        case .profile(let section):
            return section?.title ?? "Profile"
        case .profileSettings:
            return "Settings"
        case .profilePrivacy:
            return "Privacy"
        case .profileNotifications:
            return "Notifications"
            
        // Home titles
        case .home:
            return "Home"
        case .dailyCheck:
            return "Daily Check-in"
        case .insights:
            return "Insights"
        case .timeline:
            return "Timeline"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .memoryDetail(let memory):
            return memory.date.formatted(date: .long, time: .none)
        case .memoryCollection(let loved):
            return "\(loved.memories.count) memories"
        case .companionChat(let conversation):
            return conversation?.lastMessage?.timestamp.formatted(date: .abbreviated, time: .shortened)
        case .companionVoice(let session):
            return session?.duration.formatted()
        case .journal(let entry):
            return entry?.mood.description
        default:
            return nil
        }
    }
    
    var icon: String {
        switch self {
        case .memories: return "heart.fill"
        case .memoryDetail, .memoryCreation: return "square.and.pencil"
        case .memoryCollection: return "person.2.fill"
        case .journal: return "book.fill"
        case .journalCalendar: return "calendar"
        case .journalMood: return "chart.line.uptrend.xyaxis"
        case .journalPrompts: return "lightbulb.fill"
        case .companion: return "bubble.left.and.bubble.right.fill"
        case .companionChat: return "bubble.left.fill"
        case .companionVoice: return "waveform"
        case .companionInsights: return "brain"
        case .supportNetwork: return "heart.circle.fill"
        case .supportResources: return "book.closed.fill"
        case .supportGroups: return "person.3.fill"
        case .supportProfessional: return "cross.case.fill"
        case .profile: return "person.circle.fill"
        case .profileSettings: return "gear"
        case .profilePrivacy: return "lock.fill"
        case .profileNotifications: return "bell.fill"
        case .home: return "house.fill"
        case .dailyCheck: return "checkmark.circle.fill"
        case .insights: return "chart.bar.fill"
        case .timeline: return "clock.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .memories, .memoryDetail, .memoryCreation, .memoryCollection:
            return .red
        case .journal, .journalCalendar, .journalMood, .journalPrompts:
            return .blue
        case .companion, .companionChat, .companionVoice, .companionInsights:
            return .green
        case .supportNetwork, .supportResources, .supportGroups, .supportProfessional:
            return .purple
        case .profile, .profileSettings, .profilePrivacy, .profileNotifications:
            return .orange
        case .home, .dailyCheck, .insights, .timeline:
            return .indigo
        }
    }
}

enum MemoryType {
    case moment, feeling, update, challenge, win
    
    var name: String {
        switch self {
        case .moment: return "Magical Moment"
        case .feeling: return "Heartfelt Feeling"
        case .update: return "Life Update"
        case .challenge: return "Difficult Time"
        case .win: return "Shared Win"
        }
    }
}

enum ProfileSection {
    case loved, preferences, security, support
    
    var title: String {
        switch self {
        case .loved: return "Loved Ones"
        case .preferences: return "Preferences"
        case .security: return "Security"
        case .support: return "Support"
        }
    }
    
    var description: String {
        switch self {
        case .loved: return "Manage your loved ones' profiles"
        case .preferences: return "Customize your experience"
        case .security: return "Privacy and security settings"
        case .support: return "Get help and support"
        }
    }
}
