import Foundation

/// Represents a memory of a conversation with context about the person being grieved
struct PersonMemory {
    let name: String
    var relationship: String
    var mentionedQualities: Set<String>
    var significantDates: [String: Date]
    var sharedMemories: [String]
    var preferences: [String: String]
}

/// Manages conversation context and emotional memory
class ConversationMemory {
    private var personMemories: [String: PersonMemory] = [:]
    private var recentEmotionalStates: [(emotion: String, intensity: Int, date: Date)] = []
    private var significantTopics: Set<String> = []
    
    /// Adds or updates information about a person being grieved
    func updatePersonMemory(name: String, 
                          relationship: String? = nil,
                          qualities: Set<String>? = nil,
                          dates: [String: Date]? = nil,
                          memories: [String]? = nil,
                          preferences: [String: String]? = nil) {
        if var person = personMemories[name] {
            if let relationship = relationship {
                person.relationship = relationship
            }
            if let qualities = qualities {
                person.mentionedQualities.formUnion(qualities)
            }
            if let dates = dates {
                person.significantDates.merge(dates) { (_, new) in new }
            }
            if let memories = memories {
                person.sharedMemories.append(contentsOf: memories)
            }
            if let preferences = preferences {
                person.preferences.merge(preferences) { (_, new) in new }
            }
            personMemories[name] = person
        } else {
            personMemories[name] = PersonMemory(
                name: name,
                relationship: relationship ?? "unknown",
                mentionedQualities: qualities ?? [],
                significantDates: dates ?? [:],
                sharedMemories: memories ?? [],
                preferences: preferences ?? [:]
            )
        }
    }
    
    /// Records an emotional state for tracking emotional patterns
    func recordEmotionalState(_ emotion: String, intensity: Int) {
        recentEmotionalStates.append((emotion, intensity, Date()))
        // Keep only last 30 days of emotional states
        let thirtyDaysAgo = Date().addingTimeInterval(-30 * 24 * 60 * 60)
        recentEmotionalStates = recentEmotionalStates.filter { $0.date > thirtyDaysAgo }
    }
    
    /// Adds a significant topic from the conversation
    func addSignificantTopic(_ topic: String) {
        significantTopics.insert(topic)
    }
    
    /// Gets emotional pattern analysis for the last 30 days
    func getEmotionalPattern() -> [String: (count: Int, averageIntensity: Double)] {
        var patterns: [String: (count: Int, totalIntensity: Int)] = [:]
        
        for state in recentEmotionalStates {
            let current = patterns[state.emotion] ?? (count: 0, totalIntensity: 0)
            patterns[state.emotion] = (
                count: current.count + 1,
                totalIntensity: current.totalIntensity + state.intensity
            )
        }
        
        return patterns.mapValues { value in
            (count: value.count, averageIntensity: Double(value.totalIntensity) / Double(value.count))
        }
    }
    
    /// Gets personalized context for response generation
    func getPersonalizedContext(forName name: String) -> [String: Any] {
        guard let person = personMemories[name] else {
            return [:]
        }
        
        return [
            "name": person.name,
            "relationship": person.relationship,
            "qualities": Array(person.mentionedQualities),
            "memories": person.sharedMemories,
            "preferences": person.preferences
        ]
    }
    
    /// Gets upcoming significant dates
    func getUpcomingDates(withinDays days: Int = 30) -> [(name: String, occasion: String, date: Date)] {
        let upcoming = Date().addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
        var dates: [(name: String, occasion: String, date: Date)] = []
        
        for (name, person) in personMemories {
            for (occasion, date) in person.significantDates {
                // Convert the date to this year
                let calendar = Calendar.current
                let thisYear = calendar.component(.year, from: Date())
                if var dateThisYear = calendar.date(from: calendar.dateComponents([.month, .day], from: date)) {
                    dateThisYear = calendar.date(byAdding: .year, value: thisYear, to: dateThisYear) ?? dateThisYear
                    
                    if dateThisYear > Date() && dateThisYear <= upcoming {
                        dates.append((name: name, occasion: occasion, date: dateThisYear))
                    }
                }
            }
        }
        
        return dates.sorted { $0.date < $1.date }
    }
    
    /// Gets common themes or topics from conversations
    func getCommonThemes() -> Set<String> {
        return significantTopics
    }
}
