import SwiftUI

struct SupportResourcesView: View {
    let emotion: String
    let intensity: Int
    @StateObject private var viewModel = SupportResourcesViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Recommendation Card
                    if !viewModel.supportRecommendation.isEmpty {
                        RecommendationCard(message: viewModel.supportRecommendation)
                    }
                    
                    // Available Contacts
                    if !viewModel.availableContacts.isEmpty {
                        ContactsSection(contacts: viewModel.availableContacts)
                    }
                    
                    // Professional Resources
                    ResourcesSection(resources: viewModel.professionalResources)
                }
                .padding()
            }
            .navigationTitle("Support & Resources")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            viewModel.loadSupport(forEmotion: emotion, intensity: intensity)
        }
    }
}

struct RecommendationCard: View {
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(message)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ContactsSection: View {
    let contacts: [SupportContact]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Available Contacts")
                .font(.headline)
            
            ForEach(contacts, id: \.name) { contact in
                ContactCard(contact: contact)
            }
        }
    }
}

struct ContactCard: View {
    let contact: SupportContact
    @State private var showingContactOptions = false
    
    var body: some View {
        Button(action: { showingContactOptions = true }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(contact.name)
                        .font(.headline)
                    Text(contact.relationship)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .actionSheet(isPresented: $showingContactOptions) {
            var buttons: [ActionSheet.Button] = []
            
            for method in contact.contactMethods {
                switch method {
                case .phone(let number):
                    buttons.append(.default(Text("Call \(contact.name)")) {
                        guard let url = URL(string: "tel://\(number)") else { return }
                        UIApplication.shared.open(url)
                    })
                case .message(let number):
                    buttons.append(.default(Text("Message \(contact.name)")) {
                        guard let url = URL(string: "sms://\(number)") else { return }
                        UIApplication.shared.open(url)
                    })
                case .email(let email):
                    buttons.append(.default(Text("Email \(contact.name)")) {
                        guard let url = URL(string: "mailto:\(email)") else { return }
                        UIApplication.shared.open(url)
                    })
                }
            }
            
            buttons.append(.cancel())
            
            return ActionSheet(
                title: Text("Contact \(contact.name)"),
                message: Text("Choose how you'd like to reach out"),
                buttons: buttons
            )
        }
    }
}

struct ResourcesSection: View {
    let resources: [SupportResource]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Professional Support")
                .font(.headline)
            
            ForEach(resources, id: \.name) { resource in
                ResourceCard(resource: resource)
            }
        }
    }
}

struct ResourceCard: View {
    let resource: SupportResource
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(resource.name)
                    .font(.headline)
                Spacer()
                ResourceTypeTag(type: resource.type)
            }
            
            Text(resource.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Available: \(resource.availabilityHours)")
                        .font(.caption)
                    Text(resource.contactInfo)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                if let website = resource.website {
                    Button(action: {
                        UIApplication.shared.open(website)
                    }) {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ResourceTypeTag: View {
    let type: SupportResource.ResourceType
    
    var color: Color {
        switch type {
        case .crisis: return .red
        case .counseling: return .blue
        case .support_group: return .green
        case .meditation: return .purple
        case .educational: return .orange
        }
    }
    
    var text: String {
        switch type {
        case .crisis: return "Crisis"
        case .counseling: return "Counseling"
        case .support_group: return "Support Group"
        case .meditation: return "Meditation"
        case .educational: return "Educational"
        }
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

class SupportResourcesViewModel: ObservableObject {
    @Published var supportRecommendation = ""
    @Published var availableContacts: [SupportContact] = []
    @Published var professionalResources: [SupportResource] = []
    
    private let supportManager = SupportNetworkManager.shared
    
    func loadSupport(forEmotion emotion: String, intensity: Int) {
        supportRecommendation = supportManager.getSupportRecommendation(
            forEmotion: emotion,
            intensity: intensity
        )
        
        // Load contacts
        availableContacts = supportManager.getAllTrustedContacts()
        
        // Load resources based on emotional state
        var resourceTypes: [SupportResource.ResourceType] = []
        
        if intensity > 8 {
            resourceTypes.append(.crisis)
        }
        
        switch emotion {
        case "deep_grief", "raw_pain":
            resourceTypes.append(contentsOf: [.counseling, .support_group])
        case "anxiety":
            resourceTypes.append(contentsOf: [.meditation, .counseling])
        case "anger":
            resourceTypes.append(contentsOf: [.counseling, .support_group])
        case "numbness":
            resourceTypes.append(contentsOf: [.support_group, .meditation])
        default:
            resourceTypes.append(.support_group)
        }
        
        professionalResources = resourceTypes.flatMap { type in
            supportManager.getResources(ofType: type)
        }
    }
}
