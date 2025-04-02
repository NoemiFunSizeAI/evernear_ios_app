import SwiftUI

struct BrandedHeader: View {
    let title: String
    var subtitle: String?
    var showLogo: Bool = true
    var style: HeaderStyle = .standard
    var animation: LogoAnimation?
    var onLogoTap: (() -> Void)?
    
    // Accessibility
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var headingLevel: AccessibilityHeadingLevel = .h1
    var isAccessibilityElement: Bool = true
    
    @Environment(\.sizeCategory) private var sizeCategory
    
    enum HeaderStyle {
        case standard    // Light background
        case inverted   // Dark background
        case custom(backgroundColor: Color, textColor: Color)
        
        var backgroundColor: Color {
            switch self {
            case .standard: return Color(.systemBackground)
            case .inverted: return Color(.systemGray6)
            case .custom(let bgColor, _): return bgColor
            }
        }
        
        var textColor: Color {
            switch self {
            case .standard: return Color(.label)
            case .inverted: return .white
            case .custom(_, let txtColor): return txtColor
            }
        }
        
        var logoStyle: LogoStyle {
            switch self {
            case .standard: return .standard
            case .inverted: return .inverted
            case .custom(_, let txtColor): return .custom(txtColor)
            }
        }
    }
    
    private var dynamicSpacing: CGFloat {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge: return 16
        case .accessibilityExtraExtraLarge: return 14
        case .accessibilityExtraLarge: return 12
        case .accessibilityLarge: return 10
        default: return 8
        }
    }
    
    var body: some View {
        VStack(spacing: dynamicSpacing) {
            if showLogo {
                LogoView.small
                    .withStyle(style.logoStyle)
                    .if(animation != nil) { view in
                        view.withAnimation(animation!)
                    }
                    .if(onLogoTap != nil) { view in
                        view.withTapAction(onLogoTap!)
                            .withAccessibilityHint("Double tap to interact with logo")
                    }
                    .if(!isAccessibilityElement) { view in
                        view.accessibilityHidden()
                    }
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(style.textColor)
                .accessibilityHeading(headingLevel)
                .accessibilityAddTraits(.isHeader)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(style.textColor.opacity(0.8))
                    .accessibilityLabel("Subtitle: \(subtitle)")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(style.backgroundColor)
        // Accessibility for the entire header
        .if(isAccessibilityElement) { view in
            view.accessibilityElement(children: .combine)
                .accessibilityLabel(accessibilityLabel ?? title)
                .if(accessibilityHint != nil) { view in
                    view.accessibilityHint(accessibilityHint!)
                }
        }
    }
}

// MARK: - Modifiers
extension BrandedHeader {
    func withSubtitle(_ text: String) -> BrandedHeader {
        var header = self
        header.subtitle = text
        return header
    }
    
    func withoutLogo() -> BrandedHeader {
        var header = self
        header.showLogo = false
        return header
    }
    
    func withStyle(_ style: HeaderStyle) -> BrandedHeader {
        var header = self
        header.style = style
        return header
    }
    
    func withLogoAnimation(_ animation: LogoAnimation) -> BrandedHeader {
        var header = self
        header.animation = animation
        return header
    }
    
    func onLogoTap(_ action: @escaping () -> Void) -> BrandedHeader {
        var header = self
        header.onLogoTap = action
        return header
    }
    
    // Accessibility modifiers
    func withAccessibilityLabel(_ label: String) -> BrandedHeader {
        var header = self
        header.accessibilityLabel = label
        return header
    }
    
    func withAccessibilityHint(_ hint: String) -> BrandedHeader {
        var header = self
        header.accessibilityHint = hint
        return header
    }
    
    func withHeadingLevel(_ level: AccessibilityHeadingLevel) -> BrandedHeader {
        var header = self
        header.headingLevel = level
        return header
    }
    
    func accessibilityHidden() -> BrandedHeader {
        var header = self
        header.isAccessibilityElement = false
        return header
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Standard header with accessibility
        BrandedHeader(title: "Welcome")
            .withAccessibilityLabel("Welcome to EverNear")
            .withAccessibilityHint("Main app header with logo")
            .withHeadingLevel(.h1)
        BrandedHeader(title: "Welcome")
            .withSubtitle("Your grief companion")
            .withLogoAnimation(.fadeIn)
        
        BrandedHeader(title: "Memories")
            .withStyle(.inverted)
            .withLogoAnimation(.popIn)
        
        BrandedHeader(title: "Support Network")
            .withStyle(.custom(backgroundColor: .blue.opacity(0.1), textColor: .blue))
            .withoutLogo()
        
        BrandedHeader(title: "Daily Check-in")
            .onLogoTap {
                print("Logo tapped!")
            }
    }
}
