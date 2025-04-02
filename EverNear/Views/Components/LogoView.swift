import SwiftUI

// MARK: - Logo Configurations
enum LogoSize {
    case tiny      // For small UI elements
    case small     // For navigation bars
    case medium    // For headers
    case large     // For splash screen
    case custom(CGFloat)
    
    var dimension: CGFloat {
        switch self {
        case .tiny: return 24
        case .small: return 44
        case .medium: return 120
        case .large: return 200
        case .custom(let size): return size
        }
    }
}

enum LogoStyle {
    case standard    // Original colors
    case monochrome  // Single color
    case inverted    // For dark backgrounds
    case custom(Color)
    
    var tintColor: Color? {
        switch self {
        case .standard: return nil
        case .monochrome: return .primary
        case .inverted: return .white
        case .custom(let color): return color
        }
    }
}

enum LogoAnimation {
    case fadeIn
    case popIn
    case slideIn(Edge)
    case pulse
    case bounce
    case spin
    
    var duration: Double {
        switch self {
        case .fadeIn: return 0.6
        case .popIn: return 0.5
        case .slideIn: return 0.7
        case .pulse: return 1.5
        case .bounce: return 0.8
        case .spin: return 1.0
        }
    }
}

// MARK: - Logo View
struct LogoView: View {
    let size: LogoSize
    var style: LogoStyle = .standard
    var animation: LogoAnimation?
    var onTapAction: (() -> Void)?
    var accessibilityLabel: String = "EverNear Logo"
    var accessibilityHint: String?
    var isAccessibilityElement: Bool = true
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var offset: CGSize = .zero
    @Environment(\AccessibilityReduceMotion) private var reduceMotion
    
    private var baseImage: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .if(style.tintColor != nil) { view in
                view.renderingMode(.template)
                    .foregroundColor(style.tintColor)
            }
    }
    
    var body: some View {
        baseImage
            .frame(width: size.dimension, height: size.dimension)
            .scaleEffect(scale)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .offset(offset)
            .onAppear(perform: startAnimation)
            .onTapGesture(perform: handleTap)
            // Accessibility
            .if(isAccessibilityElement) { view in
                view.accessibilityElement(children: .ignore)
                    .accessibilityLabel(accessibilityLabel)
                    .if(accessibilityHint != nil) { view in
                        view.accessibilityHint(accessibilityHint!)
                    }
                    .if(onTapAction != nil) { view in
                        view.accessibilityAddTraits(.isButton)
                    }
                    .if(animation != nil) { view in
                        view.accessibilityAction(.magicTap) {
                            startAnimation()
                        }
                    }
            }
    }
    
    // MARK: - Animation Logic
    private func startAnimation() {
        guard let animation = animation else { return }
        
        // If reduce motion is enabled, only use fade animations
        if reduceMotion {
            opacity = 0
            withAnimation(.easeIn(duration: 0.3)) {
                opacity = 1
            }
            return
        }
        
        switch animation {
        case .fadeIn:
            opacity = 0
            withAnimation(.easeIn(duration: animation.duration)) {
                opacity = 1
            }
            
        case .popIn:
            scale = 0
            opacity = 0
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1
                opacity = 1
            }
            
        case .slideIn(let edge):
            let distance = size.dimension * 2
            switch edge {
            case .top: offset.height = -distance
            case .bottom: offset.height = distance
            case .leading: offset.width = -distance
            case .trailing: offset.width = distance
            }
            opacity = 0
            
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                offset = .zero
                opacity = 1
            }
            
        case .pulse:
            withAnimation(.easeInOut(duration: animation.duration).repeatForever()) {
                scale = 1.1
            }
            
        case .bounce:
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5).repeatForever()) {
                scale = 1.2
            }
            
        case .spin:
            withAnimation(.linear(duration: animation.duration).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
    
    private func handleTap() {
        guard let action = onTapAction else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            scale = 0.95
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.0
            }
            action()
        }
    }
}

// MARK: - View Modifier
extension View {
    fileprivate func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> AnyView {
        if condition {
            return AnyView(transform(self))
        }
        return AnyView(self)
    }
}

// MARK: - Convenience Initializers
extension LogoView {
    static var tiny: LogoView { 
        LogoView(size: .tiny)
            .withAccessibilitySize("tiny")
    }
    
    static var small: LogoView { 
        LogoView(size: .small)
            .withAccessibilitySize("small")
    }
    
    static var medium: LogoView { 
        LogoView(size: .medium)
            .withAccessibilitySize("medium")
    }
    
    static var large: LogoView { 
        LogoView(size: .large)
            .withAccessibilitySize("large")
    }
    
    func withStyle(_ style: LogoStyle) -> LogoView {
        var view = self
        view.style = style
        return view
    }
    
    func withAnimation(_ animation: LogoAnimation) -> LogoView {
        var view = self
        view.animation = animation
        return view
    }
    
    func withTapAction(_ action: @escaping () -> Void) -> LogoView {
        var view = self
        view.onTapAction = action
        return view
    }
    
    // Accessibility modifiers
    func withAccessibilityLabel(_ label: String) -> LogoView {
        var view = self
        view.accessibilityLabel = label
        return view
    }
    
    func withAccessibilityHint(_ hint: String) -> LogoView {
        var view = self
        view.accessibilityHint = hint
        return view
    }
    
    private func withAccessibilitySize(_ size: String) -> LogoView {
        withAccessibilityLabel("\(size) EverNear logo")
    }
    
    func accessibilityHidden() -> LogoView {
        var view = self
        view.isAccessibilityElement = false
        return view
    }
    
    func withAccessibilityAction(name: String, action: @escaping () -> Void) -> LogoView {
        var view = self
        view.accessibilityHint = name
        view.onTapAction = action
        return view
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        Group {
            LogoView.small.withStyle(.standard)
            LogoView.medium.withStyle(.monochrome)
            LogoView.medium.withStyle(.inverted)
                .background(Color.black)
            LogoView.medium.withStyle(.custom(.blue))
        }
        
        Group {
            LogoView.medium.withAnimation(.fadeIn)
            LogoView.medium.withAnimation(.popIn)
            LogoView.medium.withAnimation(.slideIn(.leading))
            LogoView.medium.withAnimation(.pulse)
            LogoView.medium.withAnimation(.bounce)
            LogoView.medium.withAnimation(.spin)
        }
    }
    .padding()
}
