import AVFoundation
import Speech

class VoiceEmotionAnalyzer: ObservableObject {
    @Published var currentEmotion: EmotionState = .neutral
    @Published var emotionConfidence: Double = 0.0
    
    // Voice metrics
    private var pitch: Double = 0.0
    private var volume: Double = 0.0
    private var speakingRate: Double = 0.0
    private var pauseCount: Int = 0
    private var emotionKeywords: Set<String> = []
    
    enum EmotionState: String {
        case joy, sadness, anger, fear, neutral, grief
        
        var description: String {
            switch self {
            case .joy: return "joyful"
            case .sadness: return "sad"
            case .anger: return "angry"
            case .fear: return "anxious"
            case .neutral: return "neutral"
            case .grief: return "grieving"
            }
        }
        
        var voiceAdjustment: VoiceAdjustment {
            switch self {
            case .joy:
                return VoiceAdjustment(rate: 0.5, pitch: 1.1, volume: 0.8)
            case .sadness, .grief:
                return VoiceAdjustment(rate: 0.45, pitch: 0.95, volume: 0.7)
            case .anger:
                return VoiceAdjustment(rate: 0.5, pitch: 0.9, volume: 0.7)
            case .fear:
                return VoiceAdjustment(rate: 0.48, pitch: 1.0, volume: 0.75)
            case .neutral:
                return VoiceAdjustment(rate: 0.5, pitch: 1.0, volume: 0.8)
            }
        }
    }
    
    struct VoiceAdjustment {
        let rate: Float
        let pitch: Float
        let volume: Float
    }
    
    init() {
        loadEmotionKeywords()
    }
    
    private func loadEmotionKeywords() {
        // Load emotion-related keywords for each category
        emotionKeywords = [
            // Joy
            "happy", "excited", "grateful", "blessed", "peaceful",
            // Sadness
            "miss", "lost", "alone", "empty", "sad",
            // Anger
            "angry", "frustrated", "unfair", "upset",
            // Fear
            "scared", "worried", "anxious", "afraid",
            // Grief
            "grief", "mourning", "remembering", "gone", "memories"
        ]
    }
    
    func analyzeVoiceMetrics(_ buffer: AVAudioPCMBuffer) {
        // Analyze pitch using AVAudioEngine
        analyzePitch(buffer)
        
        // Analyze volume
        analyzeVolume(buffer)
        
        // Update emotion based on voice metrics
        updateEmotionFromMetrics()
    }
    
    private func analyzePitch(_ buffer: AVAudioPCMBuffer) {
        // Implementation would use AVAudioEngine's pitch detection
        // This is a simplified version
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameCount = UInt32(buffer.frameLength)
        
        var sumPitch: Float = 0
        for i in 0..<Int(frameCount) {
            sumPitch += abs(channelData[i])
        }
        
        pitch = Double(sumPitch / Float(frameCount))
    }
    
    private func analyzeVolume(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameCount = UInt32(buffer.frameLength)
        
        var sumVolume: Float = 0
        for i in 0..<Int(frameCount) {
            sumVolume += channelData[i] * channelData[i]
        }
        
        volume = Double(sqrt(sumVolume / Float(frameCount)))
    }
    
    func analyzeText(_ text: String) {
        // Analyze emotional keywords in text
        let words = text.lowercased().components(separatedBy: .whitespacesAndNewlines)
        let emotionalWords = words.filter { emotionKeywords.contains($0) }
        
        // Count pauses (using punctuation as proxy)
        pauseCount = text.filter { ",.?!...".contains($0) }.count
        
        // Update emotion based on text analysis
        updateEmotionFromText(words: Set(words), emotionalWords: Set(emotionalWords))
    }
    
    private func updateEmotionFromMetrics() {
        // Combine voice metrics to determine emotion
        // High pitch + High volume often indicates joy or anger
        // Low pitch + Low volume often indicates sadness or grief
        // Rapid speech rate might indicate anxiety or excitement
        
        var newEmotion: EmotionState = .neutral
        var confidence: Double = 0.5
        
        if pitch > 0.7 && volume > 0.7 {
            if speakingRate > 0.7 {
                newEmotion = .joy
                confidence = 0.8
            } else {
                newEmotion = .anger
                confidence = 0.7
            }
        } else if pitch < 0.3 && volume < 0.3 {
            if pauseCount > 5 {
                newEmotion = .grief
                confidence = 0.9
            } else {
                newEmotion = .sadness
                confidence = 0.7
            }
        }
        
        updateEmotionState(newEmotion, confidence: confidence)
    }
    
    private func updateEmotionFromText(words: Set<String>, emotionalWords: Set<String>) {
        // Determine emotion based on keyword frequency and context
        var emotionScores: [EmotionState: Double] = [:]
        
        // Score each emotion based on keywords
        for word in emotionalWords {
            switch word {
            case "happy", "excited", "grateful", "blessed", "peaceful":
                emotionScores[.joy, default: 0] += 1
            case "miss", "lost", "alone", "empty", "sad":
                emotionScores[.sadness, default: 0] += 1
            case "angry", "frustrated", "unfair", "upset":
                emotionScores[.anger, default: 0] += 1
            case "scared", "worried", "anxious", "afraid":
                emotionScores[.fear, default: 0] += 1
            case "grief", "mourning", "remembering", "gone", "memories":
                emotionScores[.grief, default: 0] += 1
            default:
                break
            }
        }
        
        // Find dominant emotion
        if let (emotion, score) = emotionScores.max(by: { $0.value < $1.value }) {
            let confidence = min(score / Double(words.count) + 0.5, 0.95)
            updateEmotionState(emotion, confidence: confidence)
        }
    }
    
    private func updateEmotionState(_ emotion: EmotionState, confidence: Double) {
        DispatchQueue.main.async {
            // Only update if we're more confident about the new emotion
            if confidence > self.emotionConfidence {
                self.currentEmotion = emotion
                self.emotionConfidence = confidence
            }
        }
    }
    
    func getVoiceAdjustment() -> VoiceAdjustment {
        // Return voice parameters optimized for current emotional state
        return currentEmotion.voiceAdjustment
    }
    
    func reset() {
        currentEmotion = .neutral
        emotionConfidence = 0.0
        pitch = 0.0
        volume = 0.0
        speakingRate = 0.0
        pauseCount = 0
    }
}
