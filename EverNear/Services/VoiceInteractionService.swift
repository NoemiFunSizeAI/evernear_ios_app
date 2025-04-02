import SwiftUI
import AVFoundation
import Speech

class VoiceInteractionService: NSObject, ObservableObject {
    @Published var isListening = false
    @Published var isProcessing = false
    @Published var isSpeaking = false
    @Published var transcribedText = ""
    @Published var errorMessage: String?
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var recognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // Voice settings
    var voiceRate: Float = 0.5 // Default speaking rate
    var voicePitch: Float = 1.0 // Default pitch
    var selectedVoice: AVSpeechSynthesisVoice?
    
    override init() {
        super.init()
        setupSpeech()
        speechSynthesizer.delegate = self
        
        // Select a warm, comforting voice
        if let voice = AVSpeechSynthesisVoice.speechVoices()
            .first(where: { $0.language == "en-US" && $0.quality == .enhanced }) {
            selectedVoice = voice
        }
    }
    
    private func setupSpeech() {
        recognizer = SFSpeechRecognizer()
        
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.errorMessage = nil
                case .denied:
                    self.errorMessage = "Please enable speech recognition permission"
                case .restricted:
                    self.errorMessage = "Speech recognition is restricted on this device"
                case .notDetermined:
                    self.errorMessage = "Speech recognition not yet authorized"
                @unknown default:
                    self.errorMessage = "Unknown speech recognition error"
                }
            }
        }
    }
    
    func startListening() {
        guard !isListening else { return }
        
        // Reset state
        transcribedText = ""
        errorMessage = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Could not configure audio session"
            return
        }
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            errorMessage = "Could not create speech recognition request"
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure audio input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        // Start recognition
        recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.transcribedText = result.bestTranscription.formattedString
            }
            if error != nil {
                self.stopListening()
            }
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true
        } catch {
            errorMessage = "Could not start audio engine"
            stopListening()
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        isListening = false
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    func speak(_ text: String, completion: (() -> Void)? = nil) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = voiceRate
        utterance.pitchMultiplier = voicePitch
        utterance.voice = selectedVoice
        
        // Add natural pauses for more human-like speech
        utterance.prefersAssistiveTechnologySettings = true
        
        isSpeaking = true
        speechSynthesizer.speak(utterance)
        
        // Store completion handler
        completionHandler = completion
    }
    
    private var completionHandler: (() -> Void)?
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
    
    // Voice customization
    func adjustVoiceRate(_ rate: Float) {
        voiceRate = max(0.1, min(1.0, rate))
    }
    
    func adjustVoicePitch(_ pitch: Float) {
        voicePitch = max(0.5, min(2.0, pitch))
    }
    
    func selectVoice(identifier: String) {
        if let voice = AVSpeechSynthesisVoice(identifier: identifier) {
            selectedVoice = voice
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension VoiceInteractionService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.completionHandler?()
            self.completionHandler = nil
        }
    }
}
