import UIKit
import AVFoundation

class EmotionalResponseAnalyzer {
    // Singleton instance
    static let shared = EmotionalResponseAnalyzer()
    
    // Private initializer for singleton
    private init() {
        loadEmotionPatterns()
    }
    
    // MARK: - Properties
    
    private var emotionPatterns: [String: [String]] = [:]
    private var sentimentScores: [String: Double] = [:]
    
    // MARK: - Emotion Analysis
    
    func analyzeEmotion(in text: String) -> EmotionAnalysisResult {
        let lowercasedText = text.lowercased()
        
        // Check for primary emotions
        var detectedEmotions: [Emotion: Double] = [:]
        var dominantEmotion: Emotion = .neutral
        var highestScore: Double = 0.0
        
        // Check each emotion pattern
        for emotion in Emotion.allCases {
            let emotionName = String(describing: emotion)
            if let patterns = emotionPatterns[emotionName] {
                let score = calculateEmotionScore(text: lowercasedText, patterns: patterns)
                
                if score > 0 {
                    detectedEmotions[emotion] = score
                    
                    if score > highestScore {
                        highestScore = score
                        dominantEmotion = emotion
                    }
                }
            }
        }
        
        // Calculate overall sentiment
        let sentimentScore = calculateSentimentScore(text: lowercasedText)
        let sentimentCategory = categorizeSentiment(score: sentimentScore)
        
        return EmotionAnalysisResult(
            dominantEmotion: dominantEmotion,
            detectedEmotions: detectedEmotions,
            sentimentScore: sentimentScore,
            sentimentCategory: sentimentCategory
        )
    }
    
    func suggestResponse(for analysisResult: EmotionAnalysisResult) -> String {
        // Generate appropriate response based on emotional analysis
        switch analysisResult.dominantEmotion {
        case .grief:
            return generateGriefResponse(intensity: analysisResult.detectedEmotions[.grief] ?? 0.5)
        case .sadness:
            return generateSadnessResponse(intensity: analysisResult.detectedEmotions[.sadness] ?? 0.5)
        case .anger:
            return generateAngerResponse(intensity: analysisResult.detectedEmotions[.anger] ?? 0.5)
        case .fear:
            return generateFearResponse(intensity: analysisResult.detectedEmotions[.fear] ?? 0.5)
        case .anxiety:
            return generateAnxietyResponse(intensity: analysisResult.detectedEmotions[.anxiety] ?? 0.5)
        case .joy:
            return generateJoyResponse(intensity: analysisResult.detectedEmotions[.joy] ?? 0.5)
        case .gratitude:
            return generateGratitudeResponse(intensity: analysisResult.detectedEmotions[.gratitude] ?? 0.5)
        case .nostalgia:
            return generateNostalgiaResponse(intensity: analysisResult.detectedEmotions[.nostalgia] ?? 0.5)
        case .confusion:
            return generateConfusionResponse(intensity: analysisResult.detectedEmotions[.confusion] ?? 0.5)
        case .neutral:
            return generateNeutralResponse()
        }
    }
    
    // MARK: - Helper Methods
    
    private func calculateEmotionScore(text: String, patterns: [String]) -> Double {
        var score = 0.0
        let words = text.split(separator: " ").map { String($0) }
        
        for pattern in patterns {
            if text.contains(pattern) {
                score += 1.0
                
                // Check for intensifiers
                let intensifiers = ["very", "extremely", "so", "really", "deeply", "profoundly", "overwhelmingly"]
                for intensifier in intensifiers {
                    if text.contains("\(intensifier) \(pattern)") {
                        score += 0.5
                        break
                    }
                }
            }
        }
        
        // Normalize score based on text length
        let normalizedScore = score / Double(max(1, words.count / 5))
        return min(normalizedScore, 1.0) // Cap at 1.0
    }
    
    private func calculateSentimentScore(text: String) -> Double {
        var score = 0.0
        let words = text.split(separator: " ").map { String($0) }
        
        for word in words {
            if let wordScore = sentimentScores[word] {
                score += wordScore
            }
        }
        
        // Normalize score
        return score / Double(max(1, words.count))
    }
    
    private func categorizeSentiment(score: Double) -> SentimentCategory {
        if score < -0.3 {
            return .negative
        } else if score > 0.3 {
            return .positive
        } else {
            return .neutral
        }
    }
    
    // MARK: - Response Generation
    
    private func generateGriefResponse(intensity: Double) -> String {
        let responses = [
            "I understand that grief can be overwhelming. It's a reflection of the love you have for them. Would you like to share more about what you're experiencing?",
            "Grief is a journey that takes time. I'm here to listen and support you through it. What specific feelings are coming up for you right now?",
            "The pain of loss can be profound. Remember that your feelings are valid, and there's no right way to grieve. Would it help to talk about a memory of your loved one?",
            "I hear the grief in your words. It's okay to feel this way, and it's okay to take the time you need. Would you like to explore ways to honor your feelings today?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateSadnessResponse(intensity: Double) -> String {
        let responses = [
            "I can hear the sadness in your words. It's okay to feel down sometimes. Would you like to talk more about what's bringing you down?",
            "Sadness is a natural part of the grief process. I'm here to listen whenever you need someone. Is there anything specific that triggered these feelings today?",
            "It sounds like you're having a difficult moment. Would sharing a happy memory of your loved one help right now?",
            "I understand that sadness can come in waves. Is there something I can do to support you through this moment?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateAngerResponse(intensity: Double) -> String {
        let responses = [
            "It's completely normal to feel anger as part of grief. Your feelings are valid. Would you like to talk more about what's frustrating you?",
            "Anger can be a powerful emotion during grief. It's okay to express it in a safe space. What specifically is making you feel this way?",
            "I hear your frustration. Sometimes anger comes from feeling that things are unfair or out of our control. Would it help to explore these feelings further?",
            "Your anger is understandable. Would it help to talk about ways to channel these feelings constructively?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateFearResponse(intensity: Double) -> String {
        let responses = [
            "It sounds like you're experiencing some fear. That's a common part of grief as we face a changed future. Would you like to talk about what specifically feels frightening?",
            "Fear can be overwhelming. Sometimes naming our fears can help reduce their power. Would you like to explore what's causing this feeling?",
            "I understand that fear can be part of grief. Would it help to talk about small steps that might make things feel more manageable?",
            "It's natural to feel afraid when facing significant loss. Would sharing what you're worried about help lighten the burden?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateAnxietyResponse(intensity: Double) -> String {
        let responses = [
            "I can sense you're feeling anxious. Would taking a few deep breaths together help? We could also talk through what's causing these feelings.",
            "Anxiety often comes with grief. Would it help to focus on something grounding in this moment, like describing something you can see, hear, or touch?",
            "When anxiety rises, sometimes it helps to return to the present moment. Is there something specific that's triggering these feelings right now?",
            "I understand those anxious feelings. Would it help to talk about some simple techniques that might bring a sense of calm?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateJoyResponse(intensity: Double) -> String {
        let responses = [
            "It's wonderful to hear joy in your words. Those moments are precious, especially during grief. Would you like to share more about what brought this happiness?",
            "I'm glad you're experiencing some positive emotions. Finding moments of joy doesn't diminish your love for the person you've lost. Would you like to capture this as a memory?",
            "It's beautiful to hear you expressing joy. These moments can be healing. What specifically brought this feeling today?",
            "Moments of happiness are important on the grief journey. Would you like to reflect on how these positive feelings connect to your loved one?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateGratitudeResponse(intensity: Double) -> String {
        let responses = [
            "Gratitude is a powerful emotion. It's wonderful that you're able to connect with feelings of thankfulness even during difficult times. What specifically are you feeling grateful for?",
            "I appreciate you sharing your gratitude. These feelings can be healing. Would you like to explore how gratitude connects to your grief journey?",
            "It's beautiful to hear you express gratitude. Would you like to create a gratitude memory to look back on during harder moments?",
            "Gratitude can be a gentle companion to grief. Is this something you'd like to cultivate more in your daily life?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateNostalgiaResponse(intensity: Double) -> String {
        let responses = [
            "Those nostalgic memories are precious treasures. Would you like to share more details about this particular memory?",
            "Nostalgia can bring both joy and sadness. How does revisiting this memory make you feel right now?",
            "Thank you for sharing this nostalgic moment. Would you like to preserve more details about this memory in your collection?",
            "Those moments from the past can be so meaningful. Is there a specific detail from this memory that stands out most to you?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateConfusionResponse(intensity: Double) -> String {
        let responses = [
            "It sounds like you might be feeling a bit confused or uncertain. That's completely normal during grief. Would it help to talk through what feels unclear?",
            "Grief can sometimes make things feel foggy or confusing. Would it help to break things down into smaller pieces to process?",
            "I understand that uncertainty can be difficult. Would it help to focus on just one aspect of what you're experiencing right now?",
            "When things feel confusing, sometimes it helps to ground ourselves in what we do know for certain. Would that be a helpful approach?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func generateNeutralResponse() -> String {
        let responses = [
            "Thank you for sharing that with me. How has this been affecting you lately?",
            "I appreciate you opening up. Would you like to explore this further or perhaps talk about something else?",
            "I'm here to listen and support you. Is there a specific aspect of this you'd like to discuss more?",
            "Thank you for telling me about this. Would you like to share how these thoughts connect to your feelings about your loved one?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    // MARK: - Data Loading
    
    private func loadEmotionPatterns() {
        // Load emotion patterns
        emotionPatterns = [
            "grief": ["grief", "loss", "lost", "gone", "missing", "miss", "emptiness", "void", "hollow"],
            "sadness": ["sad", "down", "blue", "unhappy", "depressed", "heartbroken", "cry", "tears", "weep"],
            "anger": ["angry", "mad", "frustrated", "upset", "furious", "rage", "unfair", "resentful"],
            "fear": ["afraid", "scared", "frightened", "terrified", "fear", "dread"],
            "anxiety": ["anxious", "worried", "nervous", "stress", "stressed", "overwhelmed", "panic"],
            "joy": ["happy", "joy", "glad", "delighted", "pleased", "smile", "laugh", "cheerful"],
            "gratitude": ["grateful", "thankful", "appreciate", "blessed", "fortunate", "thank"],
            "nostalgia": ["remember", "memory", "memories", "used to", "reminds", "reminded", "nostalgia", "nostalgic", "back then", "those days"],
            "confusion": ["confused", "unsure", "uncertain", "don't know", "not sure", "puzzled", "lost", "bewildered"],
            "neutral": []
        ]
        
        // Load sentiment scores (simplified version)
        sentimentScores = [
            // Positive words
            "good": 0.5, "great": 0.7, "excellent": 0.8, "wonderful": 0.8, "amazing": 0.8,
            "happy": 0.6, "joy": 0.7, "love": 0.8, "loved": 0.8, "beautiful": 0.6,
            "grateful": 0.7, "thankful": 0.7, "appreciate": 0.6, "blessed": 0.7,
            "peaceful": 0.5, "calm": 0.4, "hope": 0.5, "hopeful": 0.6,
            
            // Negative words
            "bad": -0.5, "terrible": -0.7, "awful": -0.7, "horrible": -0.8,
            "sad": -0.6, "grief": -0.7, "miss": -0.5, "missing": -0.5, "lost": -0.6,
            "angry": -0.7, "mad": -0.6, "upset": -0.5, "frustrated": -0.5,
            "afraid": -0.6, "scared": -0.6, "anxious": -0.6, "worried": -0.5,
            "pain": -0.6, "hurt": -0.6, "suffering": -0.7, "struggle": -0.5,
            "alone": -0.5, "lonely": -0.6, "empty": -0.5, "void": -0.6
        ]
    }
}

// MARK: - Emotion Types

enum Emotion: CaseIterable {
    case grief
    case sadness
    case anger
    case fear
    case anxiety
    case joy
    case gratitude
    case nostalgia
    case confusion
    case neutral
}

enum SentimentCategory {
    case positive
    case negative
    case neutral
}

struct EmotionAnalysisResult {
    let dominantEmotion: Emotion
    let detectedEmotions: [Emotion: Double]
    let sentimentScore: Double
    let sentimentCategory: SentimentCategory
}
