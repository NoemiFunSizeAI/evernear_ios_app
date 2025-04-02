import Foundation
import AVFoundation
import EverNear

// Test voice interaction components
class VoiceTest {
    let voiceService = VoiceInteractionService()
    let emotionAnalyzer = VoiceEmotionAnalyzer()
    let preferencesManager = VoicePreferencesManager()
    let conversationManager: ConversationFlowManager
    
    init() {
        conversationManager = ConversationFlowManager(emotionAnalyzer: emotionAnalyzer)
    }
    
    func runTests() async {
        print("\nEverNear Voice Interaction Test Suite\n")
        
        // Test voice synthesis
        print("1. Testing Voice Synthesis...")
        await testVoiceSynthesis()
        
        // Test voice recognition
        print("\n2. Testing Voice Recognition...")
        await testVoiceRecognition()
        
        // Test emotion detection
        print("\n3. Testing Emotion Detection...")
        await testEmotionDetection()
        
        // Test conversation flow
        print("\n4. Testing Conversation Flow...")
        await testConversationFlow()
        
        // Test voice preferences
        print("\n5. Testing Voice Preferences...")
        await testVoicePreferences()
        
        print("\nTest suite complete!\n")
    }
    
    private func testVoiceSynthesis() async {
        do {
            print("- Initializing speech synthesis...")
            let testPhrase = "Hello, I'm your EverNear companion."
            
            print("- Testing default voice...")
            try await withCheckedThrowingContinuation { continuation in
                voiceService.speak(testPhrase) {
                    continuation.resume()
                }
            }
            
            print("- Testing emotional voice adjustment...")
            let params = preferencesManager.getAdjustedParameters(for: .grief)
            voiceService.voiceRate = params.rate
            voiceService.voicePitch = params.pitch
            
            try await withCheckedThrowingContinuation { continuation in
                voiceService.speak("I understand this is a difficult time.") {
                    continuation.resume()
                }
            }
            
            print("✓ Voice synthesis tests passed")
        } catch {
            print("❌ Voice synthesis error: \(error)")
        }
    }
    
    private func testVoiceRecognition() async {
        print("- Starting voice recognition...")
        print("  Please speak after the beep...")
        
        // Play beep
        AudioServicesPlaySystemSound(1113)
        
        voiceService.startListening()
        
        // Wait for 5 seconds
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        voiceService.stopListening()
        
        if !voiceService.transcribedText.isEmpty {
            print("✓ Transcribed text: \(voiceService.transcribedText)")
        } else {
            print("❌ No speech detected")
        }
    }
    
    private func testEmotionDetection() async {
        print("- Testing emotion detection from text...")
        let testCases = [
            "I really miss them so much today": EmotionState.grief,
            "I'm feeling better after sharing these memories": EmotionState.joy,
            "Sometimes I get so angry that they're gone": EmotionState.anger,
            "I'm worried about moving forward alone": EmotionState.fear
        ]
        
        var passedTests = 0
        for (text, expectedEmotion) in testCases {
            emotionAnalyzer.analyzeText(text)
            if emotionAnalyzer.currentEmotion == expectedEmotion {
                passedTests += 1
                print("✓ Correctly detected \(expectedEmotion) in: \(text)")
            } else {
                print("❌ Expected \(expectedEmotion) but got \(emotionAnalyzer.currentEmotion) in: \(text)")
            }
        }
        
        print("Passed \(passedTests)/\(testCases.count) emotion detection tests")
    }
    
    private func testConversationFlow() async {
        print("- Testing conversation flow...")
        let testDialog = [
            "I miss them so much": "grief",
            "Remember when we used to cook together?": "memory",
            "I'm having a hard time today": "support",
            "Thank you for listening": "acknowledgment"
        ]
        
        for (input, context) in testDialog {
            let response = conversationManager.processUserInput(input)
            print("\nUser: \(input)")
            print("AI: \(response)")
            print("Context: \(context)")
            print("Emotion: \(emotionAnalyzer.currentEmotion)")
            print("Confidence: \(Int(emotionAnalyzer.emotionConfidence * 100))%")
        }
    }
    
    private func testVoicePreferences() async {
        print("- Testing voice preference persistence...")
        
        // Save test preferences
        preferencesManager.updateBaseRate(0.6)
        preferencesManager.updateBasePitch(1.1)
        preferencesManager.toggleEmotionalAdjustment()
        
        // Create new instance to test loading
        let newPreferences = VoicePreferencesManager()
        
        let tests = [
            ("Base rate", newPreferences.currentPreferences.baseRate == 0.6),
            ("Base pitch", newPreferences.currentPreferences.basePitch == 1.1),
            ("Emotional adjustment", newPreferences.currentPreferences.emotionalAdjustment)
        ]
        
        for (test, passed) in tests {
            print(passed ? "✓" : "❌", "\(test) persistence test", passed ? "passed" : "failed")
        }
    }
}

// Run the tests
print("Starting voice interaction tests...")
let tester = VoiceTest()
await tester.runTests()
