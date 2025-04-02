import Foundation

struct SupportContact {
    let name: String
    let relationship: String
    let contactMethods: [ContactMethod]
    let availabilityHours: [ClosedRange<Int>]
    let specialties: [String]?  // e.g., ["grief counseling", "crisis support"]
    
    enum ContactMethod {
        case phone(String)
        case email(String)
        case message(String)
    }
}

struct SupportResource {
    let name: String
    let type: ResourceType
    let description: String
    let contactInfo: String
    let availabilityHours: String
    let website: URL?
    
    enum ResourceType {
        case crisis
        case counseling
        case support_group
        case meditation
        case educational
    }
}

class SupportNetworkManager {
    static let shared = SupportNetworkManager()
    private var trustedContacts: [SupportContact] = []
    private var professionalResources: [SupportResource] = []
    
    // Get appropriate support recommendations based on emotional state
    func getSupportRecommendation(forEmotion emotion: String, intensity: Int) -> String {
        // For high-intensity emotions, prioritize immediate support
        if intensity > 8 {
            if let crisis = professionalResources.first(where: { $0.type == .crisis }) {
                return """
                I hear how much pain you're in right now. You don't have to go through this alone.
                
                Would you like to talk to someone? \(crisis.name) is available 24/7 at \(crisis.contactInfo).
                They're here to listen and support you through moments like this.
                """
            }
        }
        
        // For specific emotional states, offer targeted support
        switch emotion {
        case "deep_grief", "raw_pain":
            if let counseling = professionalResources.first(where: { $0.type == .counseling }) {
                return """
                It's okay to need extra support during these intense moments of grief.
                \(counseling.name) specializes in grief counseling and might be able to help.
                Would you like their contact information?
                """
            }
            
        case "anxiety":
            if let meditation = professionalResources.first(where: { $0.type == .meditation }) {
                return """
                When anxiety feels overwhelming, having some tools can help.
                \(meditation.name) offers guided meditations specifically for grief and anxiety.
                Would you like to learn more about this resource?
                """
            }
            
        case "numbness", "anger":
            if let group = professionalResources.first(where: { $0.type == .support_group }) {
                return """
                Sometimes sharing with others who understand can help these feelings feel less isolating.
                \(group.name) hosts grief support groups where you can connect with others who get it.
                Would you like to know more about their meetings?
                """
            }
            
        default:
            break
        }
        
        // Default to checking available trusted contacts
        let availableContacts = getAvailableContacts()
        if let contact = availableContacts.first {
            return """
            Would you like to connect with someone who cares about you?
            \(contact.name) is available to talk if you'd like some support.
            """
        }
        
        return "Would you like to explore some support options? I can help you find resources that match what you need right now."
    }
    
    // Get currently available trusted contacts based on time of day
    private func getAvailableContacts() -> [SupportContact] {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        
        return trustedContacts.filter { contact in
            contact.availabilityHours.contains { range in
                range.contains(currentHour)
            }
        }
    }
    
    // Add a trusted contact
    func addTrustedContact(_ contact: SupportContact) {
        trustedContacts.append(contact)
    }
    
    // Add a professional resource
    func addProfessionalResource(_ resource: SupportResource) {
        professionalResources.append(resource)
    }
    
    // Get filtered resources by type
    func getResources(ofType type: SupportResource.ResourceType) -> [SupportResource] {
        return professionalResources.filter { $0.type == type }
    }
    
    // Get all trusted contacts
    func getAllTrustedContacts() -> [SupportContact] {
        return trustedContacts
    }
}
