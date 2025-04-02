import Foundation
import AVFoundation

class VoicePreferencesManager: ObservableObject {
    @Published var currentPreferences: VoicePreferences {
        didSet {
            savePreferences()
        }
    }
    
    struct VoicePreferences: Codable {
        var voiceIdentifier: String
        var baseRate: Float
        var basePitch: Float
        var baseVolume: Float
        var emotionalAdjustment: Bool
        var useEnhancedVoice: Bool
        var autoPlayResponses: Bool
        var reducedMotion: Bool
        
        static var `default`: VoicePreferences {
            VoicePreferences(
                voiceIdentifier: "",  // Will be set in init
                baseRate: 0.5,
                basePitch: 1.0,
                baseVolume: 0.8,
                emotionalAdjustment: true,
                useEnhancedVoice: true,
                autoPlayResponses: true,
                reducedMotion: false
            )
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let preferencesKey = "VoicePreferences"
    
    init() {
        // Load saved preferences or use defaults
        if let data = userDefaults.data(forKey: preferencesKey),
           let preferences = try? JSONDecoder().decode(VoicePreferences.self, from: data) {
            self.currentPreferences = preferences
        } else {
            // Initialize with default preferences
            var defaults = VoicePreferences.default
            
            // Select best available voice
            if let preferredVoice = selectPreferredVoice() {
                defaults.voiceIdentifier = preferredVoice.identifier
            }
            
            self.currentPreferences = defaults
            savePreferences()
        }
    }
    
    private func selectPreferredVoice() -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        // Try to find an enhanced quality voice in the user's locale
        if let localeIdentifier = Locale.current.identifier,
           let enhancedVoice = voices.first(where: { voice in
               voice.language.starts(with: localeIdentifier) && voice.quality == .enhanced
           }) {
            return enhancedVoice
        }
        
        // Fall back to any enhanced English voice
        if let enhancedEnglishVoice = voices.first(where: { voice in
            voice.language.starts(with: "en") && voice.quality == .enhanced
        }) {
            return enhancedEnglishVoice
        }
        
        // Fall back to any English voice
        return voices.first { $0.language.starts(with: "en" }
    }
    
    private func savePreferences() {
        if let encoded = try? JSONEncoder().encode(currentPreferences) {
            userDefaults.set(encoded, forKey: preferencesKey)
        }
    }
    
    func updateVoice(_ identifier: String) {
        currentPreferences.voiceIdentifier = identifier
    }
    
    func updateBaseRate(_ rate: Float) {
        currentPreferences.baseRate = rate
    }
    
    func updateBasePitch(_ pitch: Float) {
        currentPreferences.basePitch = pitch
    }
    
    func updateBaseVolume(_ volume: Float) {
        currentPreferences.baseVolume = volume
    }
    
    func toggleEmotionalAdjustment() {
        currentPreferences.emotionalAdjustment.toggle()
    }
    
    func toggleEnhancedVoice() {
        currentPreferences.useEnhancedVoice.toggle()
        if currentPreferences.useEnhancedVoice,
           let enhancedVoice = selectPreferredVoice() {
            currentPreferences.voiceIdentifier = enhancedVoice.identifier
        }
    }
    
    func toggleAutoPlayResponses() {
        currentPreferences.autoPlayResponses.toggle()
    }
    
    func toggleReducedMotion() {
        currentPreferences.reducedMotion.toggle()
    }
    
    func getAdjustedParameters(for emotion: VoiceEmotionAnalyzer.EmotionState) -> (rate: Float, pitch: Float, volume: Float) {
        guard currentPreferences.emotionalAdjustment else {
            return (
                currentPreferences.baseRate,
                currentPreferences.basePitch,
                currentPreferences.baseVolume
            )
        }
        
        let adjustment = emotion.voiceAdjustment
        return (
            currentPreferences.baseRate * adjustment.rate,
            currentPreferences.basePitch * adjustment.pitch,
            currentPreferences.baseVolume * adjustment.volume
        )
    }
    
    func resetToDefaults() {
        currentPreferences = VoicePreferences.default
        if let preferredVoice = selectPreferredVoice() {
            currentPreferences.voiceIdentifier = preferredVoice.identifier
        }
    }
}
