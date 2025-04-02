import Foundation

struct SpecialDate {
    let date: Date
    let type: DateType
    let personName: String
    let description: String?
    let reminderDays: Int
    let supportLevel: SupportLevel
    
    enum DateType {
        case birthday
        case anniversary
        case holiday
        case memorial
        case tradition
        case other
    }
    
    enum SupportLevel {
        case gentle    // Light check-in
        case moderate  // More frequent check-ins
        case intensive // Proactive support offering
    }
}

class SpecialDatesManager {
    static let shared = SpecialDatesManager()
    private var specialDates: [SpecialDate] = []
    
    // Add a special date
    func addSpecialDate(_ date: SpecialDate) {
        specialDates.append(date)
    }
    
    // Get upcoming dates within the specified range
    func getUpcomingDates(withinDays days: Int = 30) -> [SpecialDate] {
        let calendar = Calendar.current
        let today = Date()
        let futureDate = calendar.date(byAdding: .day, value: days, to: today)!
        
        return specialDates.filter { specialDate in
            let dateThisYear = getDateThisYear(specialDate.date)
            return dateThisYear >= today && dateThisYear <= futureDate
        }.sorted { $0.date < $1.date }
    }
    
    // Get support message for a special date
    func getSupportMessage(for date: SpecialDate) -> String {
        let daysUntil = getDaysUntil(date.date)
        
        switch date.type {
        case .birthday:
            return """
            \(date.personName)'s birthday is coming up in \(daysUntil) days. These milestones can bring up a lot of emotions.
            Would you like to talk about how you're feeling about this approaching date?
            """
            
        case .anniversary:
            return """
            I see that an important anniversary related to \(date.personName) is approaching in \(daysUntil) days.
            I'm here if you'd like to share any thoughts or memories as this date gets closer.
            """
            
        case .holiday:
            return """
            \(date.description ?? "A holiday") is coming up in \(daysUntil) days. Holidays can be especially challenging.
            Would you like to talk about how you're planning to take care of yourself during this time?
            """
            
        case .memorial:
            return """
            The memorial date for \(date.personName) is approaching in \(daysUntil) days.
            I want you to know that all your feelings are valid, and I'm here to support you through this time.
            """
            
        case .tradition:
            return """
            In \(daysUntil) days, it will be time for \(date.description ?? "a special tradition") that you shared with \(date.personName).
            Would you like to talk about what this tradition meant to you both?
            """
            
        case .other:
            return """
            I noticed an important date related to \(date.personName) is coming up in \(daysUntil) days.
            I'm here if you'd like to talk about it.
            """
        }
    }
    
    // Get support recommendations for an upcoming date
    func getSupportRecommendations(for date: SpecialDate) -> [String] {
        var recommendations: [String] = []
        
        switch date.supportLevel {
        case .gentle:
            recommendations = [
                "Consider setting aside some quiet time for reflection",
                "Maybe look through some photos if you feel up to it",
                "Remember it's okay to take things slowly"
            ]
            
        case .moderate:
            recommendations = [
                "Consider reaching out to someone who shares these memories",
                "You might want to plan a small ritual or activity to honor them",
                "Think about what would make you feel supported on this day",
                "Remember to be gentle with yourself as the date approaches"
            ]
            
        case .intensive:
            recommendations = [
                "Consider having a trusted friend or family member with you",
                "You might want to schedule time with your counselor or support group",
                "Plan self-care activities for before, during, and after the date",
                "Remember that it's okay to ask for help or take time off",
                "Consider creating a comfort plan for the day"
            ]
        }
        
        return recommendations
    }
    
    // Private helper methods
    private func getDateThisYear(_ date: Date) -> Date {
        let calendar = Calendar.current
        let thisYear = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        var components = DateComponents()
        components.year = thisYear
        components.month = month
        components.day = day
        
        return calendar.date(from: components) ?? date
    }
    
    private func getDaysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        let dateThisYear = getDateThisYear(date)
        let today = calendar.startOfDay(for: Date())
        
        let components = calendar.dateComponents([.day], from: today, to: dateThisYear)
        return components.day ?? 0
    }
}

// Extension to handle date notifications
extension SpecialDatesManager {
    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing notifications
        center.removeAllPendingNotificationRequests()
        
        // Schedule new notifications for upcoming dates
        let upcomingDates = getUpcomingDates(withinDays: 90)
        
        for specialDate in upcomingDates {
            let dateThisYear = getDateThisYear(specialDate.date)
            let daysUntil = getDaysUntil(dateThisYear)
            
            // Schedule reminders based on support level
            let reminderDays: [Int] = {
                switch specialDate.supportLevel {
                case .gentle: return [1]
                case .moderate: return [7, 1]
                case .intensive: return [14, 7, 3, 1]
                }
            }()
            
            for days in reminderDays where days <= daysUntil {
                let content = UNMutableNotificationContent()
                content.title = "Upcoming Special Date"
                content.body = getSupportMessage(for: specialDate)
                content.sound = .default
                
                let triggerDate = Calendar.current.date(
                    byAdding: .day,
                    value: -days,
                    to: dateThisYear
                )!
                
                let components = Calendar.current.dateComponents(
                    [.year, .month, .day],
                    from: triggerDate
                )
                
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: components,
                    repeats: false
                )
                
                let request = UNNotificationRequest(
                    identifier: "SpecialDate-\(specialDate.personName)-\(days)days",
                    content: content,
                    trigger: trigger
                )
                
                center.add(request)
            }
        }
    }
}
