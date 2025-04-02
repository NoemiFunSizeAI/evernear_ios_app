import SwiftUI

struct ContextualHeader: View {
    let title: String
    let subtitle: String?
    let emotionState: EmotionState?
    @Environment(\.colorScheme) var colorScheme
    
    init(title: String, subtitle: String? = nil, emotionState: EmotionState? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.emotionState = emotionState
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title row with emotion indicator
            HStack(alignment: .center, spacing: 12) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                if let emotion = emotionState {
                    EmotionIndicator(emotion: emotion)
                }
                
                Spacer()
            }
            
            // Subtitle if present
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color.black : .white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

struct EmotionIndicator: View {
    let emotion: EmotionState
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: emotion.icon)
                .font(.system(size: 14))
            
            Text(emotion.label)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(emotion.color.opacity(0.15))
        )
        .foregroundColor(emotion.color)
    }
}

extension EmotionState {
    var icon: String {
        switch self {
        case .joy: return "sun.max.fill"
        case .grief: return "cloud.rain.fill"
        case .anger: return "flame.fill"
        case .fear: return "exclamationmark.triangle.fill"
        case .neutral: return "circle.fill"
        }
    }
    
    var label: String {
        switch self {
        case .joy: return "Joyful"
        case .grief: return "Grieving"
        case .anger: return "Angry"
        case .fear: return "Anxious"
        case .neutral: return "Neutral"
        }
    }
    
    var color: Color {
        switch self {
        case .joy: return .yellow
        case .grief: return .blue
        case .anger: return .red
        case .fear: return .orange
        case .neutral: return .gray
        }
    }
}
