# Voice Interaction Guide

## Overview

The EverNear Voice Interaction System provides a natural and accessible way for users to communicate with their AI companion. This guide explains the core components and how to use them effectively.

## Core Components

### 1. VoiceInteractionService

Handles speech synthesis and recognition:

```swift
// Initialize the service
let voiceService = VoiceInteractionService()

// Start listening for user input
voiceService.startListening()

// Speak a response with emotion-adjusted parameters
voiceService.speak("I hear that you're feeling sad today. Would you like to talk about it?") {
    // Optional completion handler
}
```

### 2. VoiceEmotionAnalyzer

Detects emotions from voice and text:

```swift
// Initialize the analyzer
let emotionAnalyzer = VoiceEmotionAnalyzer()

// Analyze voice metrics
emotionAnalyzer.analyzeVoiceMetrics(audioBuffer)

// Analyze text content
emotionAnalyzer.analyzeText("I really miss them today")

// Get current emotional state
let emotion = emotionAnalyzer.currentEmotion // e.g., .grief
let confidence = emotionAnalyzer.emotionConfidence // 0.0 to 1.0
```

### 3. ConversationFlowManager

Manages context-aware conversations:

```swift
// Initialize with emotion analyzer
let flowManager = ConversationFlowManager(emotionAnalyzer: emotionAnalyzer)

// Process user input and get response
let response = flowManager.processUserInput("I remember when we used to cook together")

// Get voice parameters for current emotional context
let voiceParams = flowManager.getVoiceParameters()
```

### 4. VoicePreferencesManager

Manages user voice preferences:

```swift
// Initialize the manager
let preferencesManager = VoicePreferencesManager()

// Update voice settings
preferencesManager.updateBaseRate(0.5)
preferencesManager.updateBasePitch(1.0)
preferencesManager.toggleEmotionalAdjustment()

// Get emotion-adjusted parameters
let params = preferencesManager.getAdjustedParameters(for: .grief)
```

## Integration Example

Here's how to integrate voice interaction into a view:

```swift
struct GriefCompanionView: View {
    @StateObject private var voiceService = VoiceInteractionService()
    @StateObject private var emotionAnalyzer = VoiceEmotionAnalyzer()
    @StateObject private var conversationManager: ConversationFlowManager
    @StateObject private var preferencesManager = VoicePreferencesManager()
    
    // Process voice input
    func handleVoiceInput() {
        // Get transcribed text
        let userInput = voiceService.transcribedText
        
        // Process through conversation manager
        let response = conversationManager.processUserInput(userInput)
        
        // Get emotion-adjusted voice parameters
        let params = preferencesManager.getAdjustedParameters(
            for: emotionAnalyzer.currentEmotion
        )
        
        // Configure voice and speak response
        voiceService.voiceRate = params.rate
        voiceService.voicePitch = params.pitch
        voiceService.speak(response)
    }
}
```

## Accessibility Considerations

1. **VoiceOver Support**
   - All voice controls have descriptive labels and hints
   - Messages include proper accessibility traits
   - Voice settings are fully VoiceOver compatible

2. **Voice Preferences**
   - Support for enhanced quality voices
   - Adjustable speaking rate and pitch
   - Motion reduction options
   - Auto-play controls

3. **Emotional Adaptation**
   - Voice parameters adjust to emotional context
   - Slower, gentler speech for grief and sadness
   - Clear, supportive tone for anxiety
   - Warm, encouraging voice for positive moments

## Privacy and Security

1. **Voice Data Handling**
   - Voice input is processed locally when possible
   - Transcription data is encrypted
   - Voice preferences are stored securely
   - Users control voice data retention

2. **User Consent**
   - Explicit permission for voice features
   - Clear privacy policy for voice data
   - Option to disable voice features
   - Control over voice data sharing

## Best Practices

1. **Voice Interaction**
   - Start with clear permission requests
   - Provide visual feedback during voice input
   - Offer text alternatives for all voice features
   - Support interruption of voice output

2. **Emotional Support**
   - Adapt voice to emotional context
   - Use appropriate pauses in speech
   - Provide gentle, supportive responses
   - Respect user's emotional state

3. **Accessibility**
   - Test with VoiceOver enabled
   - Verify voice preference persistence
   - Ensure clear audio quality
   - Support all accessibility settings

4. **Performance**
   - Monitor voice processing impact
   - Cache frequently used responses
   - Optimize voice parameter updates
   - Handle network issues gracefully

## Troubleshooting

Common issues and solutions:

1. **Voice Recognition**
   - Verify microphone permissions
   - Check audio session configuration
   - Monitor background noise
   - Handle recognition errors

2. **Speech Synthesis**
   - Verify available voices
   - Check audio output settings
   - Monitor speech queue
   - Handle interruptions

3. **Emotion Detection**
   - Validate voice metrics
   - Check confidence thresholds
   - Monitor performance impact
   - Handle edge cases

4. **Voice Preferences**
   - Verify storage access
   - Check data persistence
   - Monitor setting updates
   - Handle reset requests
