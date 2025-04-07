import Foundation

struct LovedOne: Codable, Identifiable {
    let id: String
    var name: String
    var relationship: String
    var dateOfPassing: Date
    var photo: String?
    var memories: [String] // Memory IDs
    var journalEntries: [String] // Journal Entry IDs
    var griefStage: GriefStage
    var customMilestones: [Milestone]
    var sharedMemories: [String] // Memory IDs shared by family/friends
    var supportCircle: [SupportContact]
    var lastInteraction: Date
    
    init(id: String = UUID().uuidString,
         name: String,
         relationship: String,
         dateOfPassing: Date,
         photo: String? = nil) {
        self.id = id
        self.name = name
        self.relationship = relationship
        self.dateOfPassing = dateOfPassing
        self.photo = photo
        self.memories = []
        self.journalEntries = []
        self.griefStage = .initial
        self.customMilestones = []
        self.sharedMemories = []
        self.supportCircle = []
        self.lastInteraction = Date()
    }
}

enum GriefStage: String, Codable, CaseIterable {
    case initial = "Initial Response"
    case denial = "Denial"
    case anger = "Anger"
    case bargaining = "Bargaining"
    case depression = "Depression"
    case acceptance = "Acceptance"
    case growth = "Post-Traumatic Growth"
    
    var description: String {
        switch self {
        case .initial: return "Processing the initial shock and disbelief"
        case .denial: return "Struggling to accept the reality of the loss"
        case .anger: return "Experiencing feelings of frustration and injustice"
        case .bargaining: return "Wondering about different outcomes and 'what-ifs'"
        case .depression: return "Feeling deep sadness and withdrawal"
        case .acceptance: return "Beginning to adjust to the new reality"
        case .growth: return "Finding meaning and personal growth through grief"
        }
    }
    
    var suggestedActivities: [String] {
        switch self {
        case .initial: return ["Guided breathing", "Simple journaling", "Connect with close family"]
        case .denial: return ["Memory recording", "Support group participation", "Emotional check-ins"]
        case .anger: return ["Physical exercise", "Expressive writing", "Professional counseling"]
        case .bargaining: return ["Mindfulness meditation", "Letter writing", "Group therapy"]
        case .depression: return ["Daily mood tracking", "Nature walks", "Creative expression"]
        case .acceptance: return ["Memory sharing", "New routine building", "Volunteer work"]
        case .growth: return ["Helping others", "Creating legacy projects", "Community involvement"]
        }
    }
}

struct Milestone: Codable, Identifiable {
    let id: String
    var date: Date
    var title: String
    var description: String
    var type: MilestoneType
    var completed: Bool
    
    enum MilestoneType: String, Codable {
        case birthday = "Birthday"
        case anniversary = "Anniversary"
        case holiday = "Holiday"
        case personal = "Personal"
        case memorial = "Memorial"
    }
}

struct SupportContact: Codable, Identifiable {
    let id: String
    var name: String
    var relationship: String
    var contactInfo: String
    var isEmergencyContact: Bool
    var lastContactDate: Date?
}
