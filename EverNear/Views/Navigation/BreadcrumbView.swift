import SwiftUI

struct BreadcrumbView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(navigationManager.breadcrumbs.indices, id: \.self) { index in
                    BreadcrumbItem(
                        context: navigationManager.breadcrumbs[index],
                        isLast: index == navigationManager.breadcrumbs.count - 1
                    )
                }
                
                BreadcrumbItem(
                    context: navigationManager.currentContext,
                    isLast: true,
                    isCurrent: true
                )
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 44)
        .background(colorScheme == .dark ? Color.black : .white)
    }
}

struct BreadcrumbItem: View {
    let context: NavigationContext
    let isLast: Bool
    var isCurrent: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Text(context.title)
                .font(.system(size: 14, weight: isCurrent ? .semibold : .regular))
                .foregroundColor(isCurrent ? .accentColor : .secondary)
            
            if !isLast {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isCurrent ? Color.accentColor.opacity(0.1) : .clear)
        )
    }
}

struct NavigationHeader: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var emotionManager: EmotionManager
    
    var body: some View {
        VStack(spacing: 0) {
            BreadcrumbView()
            
            ContextualHeader(
                title: navigationManager.currentContext.title,
                subtitle: navigationManager.currentContext.subtitle,
                emotionState: emotionManager.currentEmotion
            )
        }
    }
}
