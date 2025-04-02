import SwiftUI

struct NavigationBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tab
    let impact = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                NavigationButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                            impact.impactOccurred()
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(colorScheme == .dark ? Color.black : .white)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct NavigationButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 24, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? .accentColor : .gray)
                
                Text(tab.title)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .accentColor : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : .clear)
            )
        }
    }
}

enum Tab: CaseIterable {
    case home, memories, companion, journal, profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .memories: return "Memories"
        case .companion: return "Companion"
        case .journal: return "Journal"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .memories: return "heart.fill"
        case .companion: return "person.2.fill"
        case .journal: return "book.fill"
        case .profile: return "person.circle.fill"
        }
    }
}
