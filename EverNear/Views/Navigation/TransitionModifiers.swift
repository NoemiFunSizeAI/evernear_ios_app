import SwiftUI

struct SlideTransition: ViewModifier {
    let direction: Edge
    let animation: Animation
    
    func body(content: Content) -> some View {
        content
            .transition(
                .asymmetric(
                    insertion: .move(edge: direction).combined(with: .opacity),
                    removal: .move(edge: direction.opposite).combined(with: .opacity)
                )
            )
            .animation(animation, value: content)
    }
}

struct FadeScaleTransition: ViewModifier {
    func body(content: Content) -> some View {
        content
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 0.9).combined(with: .opacity),
                    removal: .scale(scale: 1.1).combined(with: .opacity)
                )
            )
    }
}

struct ContextTransition: ViewModifier {
    let depth: NavigationDepth
    
    func body(content: Content) -> some View {
        content.modifier(
            SlideTransition(
                direction: depth == .deeper ? .trailing : .leading,
                animation: .spring(response: 0.3, dampingFraction: 0.8)
            )
        )
    }
}

enum NavigationDepth {
    case deeper, shallower
}

extension Edge {
    var opposite: Edge {
        switch self {
        case .top: return .bottom
        case .leading: return .trailing
        case .bottom: return .top
        case .trailing: return .leading
        }
    }
}

extension View {
    func slideTransition(edge: Edge = .trailing) -> some View {
        modifier(SlideTransition(direction: edge, animation: .spring(response: 0.3, dampingFraction: 0.8)))
    }
    
    func fadeScaleTransition() -> some View {
        modifier(FadeScaleTransition())
    }
    
    func contextTransition(depth: NavigationDepth) -> some View {
        modifier(ContextTransition(depth: depth))
    }
}
