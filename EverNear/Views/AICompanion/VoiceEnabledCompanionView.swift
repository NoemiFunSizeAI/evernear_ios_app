import SwiftUI

struct VoiceEnabledCompanionView: View {
    @StateObject private var voiceService = VoiceInteractionService()
    @StateObject private var emotionAnalyzer = VoiceEmotionAnalyzer()
    @StateObject private var conversationManager: ConversationFlowManager
    @StateObject private var preferencesManager = VoicePreferencesManager()
    
    init() {
        let analyzer = VoiceEmotionAnalyzer()
        _conversationManager = StateObject(wrappedValue: ConversationFlowManager(emotionAnalyzer: analyzer))
    }
    @State private var messages: [CompanionMessage] = []
    @State private var isThinking = false
    @State private var showingVoiceSettings = false
    
    struct CompanionMessage: Identifiable {
        let id = UUID()
        let text: String
        let isUser: Bool
        let timestamp = Date()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            BrandedHeader(title: "AI Companion")
                .withAccessibilityLabel("Voice-enabled AI Companion")
                .withAccessibilityHint("Talk or type to interact with your companion")
                .withHeadingLevel(.h1)
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel(message.isUser ? "You said" : "Companion said")
                                .accessibilityValue(message.text)
                                .accessibilityAddTraits(.startsMedia)
                                .accessibilityAction(named: "Replay message") {
                                    if !message.isUser {
                                        voiceService.speak(message.text)
                                    }
                                }
                        }
                        if isThinking {
                            TypingIndicator()
                                .accessibilityLabel("Companion is thinking")
                        }
                    }
                    .padding()
                }
                .onChange(of: messages) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Voice Input Controls
            VStack(spacing: 12) {
                // Transcription display
                if !voiceService.transcribedText.isEmpty {
                    Text(voiceService.transcribedText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                        .accessibilityLabel("Transcribed text")
                }
                
                // Control buttons
                HStack(spacing: 20) {
                    // Settings
                    Button {
                        showingVoiceSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                    }
                    .accessibilityLabel("Voice settings")
                    
                    // Voice input button
                    Button {
                        if voiceService.isListening {
                            handleVoiceInput()
                        } else {
                            startListening()
                        }
                    } label: {
                        Image(systemName: voiceService.isListening ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.system(size: 44))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(voiceService.isListening ? .red : .blue)
                    }
                    .accessibilityLabel(voiceService.isListening ? "Stop listening" : "Start listening")
                    .accessibilityHint(voiceService.isListening ? "Double tap to process voice input" : "Double tap to start voice recognition")
                    
                    // Stop speaking
                    Button {
                        voiceService.stopSpeaking()
                    } label: {
                        Image(systemName: "speaker.slash.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Stop speaking")
                    .opacity(voiceService.isSpeaking ? 1 : 0.5)
                    .disabled(!voiceService.isSpeaking)
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .shadow(radius: 2)
        }
        .sheet(isPresented: $showingVoiceSettings) {
            VoiceSettingsView(voiceService: voiceService)
        }
        .alert("Error", isPresented: .constant(voiceService.errorMessage != nil)) {
            Button("OK") {
                voiceService.errorMessage = nil
            }
        } message: {
            Text(voiceService.errorMessage ?? "")
        }
    }
    
    private func startListening() {
        voiceService.startListening()
        
        // Accessibility feedback
        UIAccessibility.post(notification: .announcement, argument: "Listening for your message")
    }
    
    private func handleVoiceInput() {
        guard !voiceService.transcribedText.isEmpty else { return }
        
        // Stop listening and add user message
        voiceService.stopListening()
        let userMessage = voiceService.transcribedText
        addMessage(userMessage, isUser: true)
        
        // Process with AI companion
        isThinking = true
        processAIResponse(to: userMessage)
    }
    
    private func processAIResponse(to userMessage: String) {
        // Process through conversation manager
        let response = conversationManager.processUserInput(userMessage)
        isThinking = false
        addMessage(response, isUser: false)
        
        // Get emotion-adjusted voice parameters
        let params = preferencesManager.getAdjustedParameters(for: emotionAnalyzer.currentEmotion)
        
        // Configure voice service with current preferences
        voiceService.voiceRate = params.rate
        voiceService.voicePitch = params.pitch
        if let voice = AVSpeechSynthesisVoice(identifier: preferencesManager.currentPreferences.voiceIdentifier) {
            voiceService.selectedVoice = voice
        }
        
        // Speak response if auto-play is enabled
        if preferencesManager.currentPreferences.autoPlayResponses {
            voiceService.speak(response) {
                // Enable listening after speaking
                if UIAccessibility.isVoiceOverRunning {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        startListening()
                    }
                }
            }
        }
    }
    
    private func addMessage(_ text: String, isUser: Bool) {
        let message = CompanionMessage(text: text, isUser: isUser)
        messages.append(message)
        
        // Accessibility feedback
        if !isUser {
            UIAccessibility.post(notification: .announcement, argument: "New message from companion")
        }
    }
}

// MARK: - Supporting Views
struct MessageBubble: View {
    let message: VoiceEnabledCompanionView.CompanionMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding()
                .background(message.isUser ? Color.blue : Color(.systemGray5))
                .foregroundColor(message.isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var animationOffset = 0.0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .opacity(0.5)
                    .offset(y: animationOffset)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animationOffset
                    )
            }
        }
        .onAppear {
            animationOffset = -5
        }
    }
}

struct VoiceSettingsView: View {
    @ObservedObject var voiceService: VoiceInteractionService
    @ObservedObject var preferencesManager: VoicePreferencesManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Voice Settings")) {
                    VStack(alignment: .leading) {
                        Text("Speaking Rate")
                        Slider(
                            value: Binding(
                                get: { Double(preferencesManager.currentPreferences.baseRate) },
                                set: { preferencesManager.updateBaseRate(Float($0)) }
                            ),
                            in: 0.1...1.0
                        )
                        .accessibilityValue("\(Int(preferencesManager.currentPreferences.baseRate * 100))%")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Voice Pitch")
                        Slider(
                            value: Binding(
                                get: { Double(preferencesManager.currentPreferences.basePitch) },
                                set: { preferencesManager.updateBasePitch(Float($0)) }
                            ),
                            in: 0.5...2.0
                        )
                        .accessibilityValue("\(Int(preferencesManager.currentPreferences.basePitch * 100))%")
                    }
                    
                    Toggle("Use Enhanced Voice Quality", isOn: Binding(
                        get: { preferencesManager.currentPreferences.useEnhancedVoice },
                        set: { _ in preferencesManager.toggleEnhancedVoice() }
                    ))
                    
                    Toggle("Adjust Voice for Emotions", isOn: Binding(
                        get: { preferencesManager.currentPreferences.emotionalAdjustment },
                        set: { _ in preferencesManager.toggleEmotionalAdjustment() }
                    ))
                }
                
                Section(header: Text("Playback Settings")) {
                    Toggle("Auto-Play Responses", isOn: Binding(
                        get: { preferencesManager.currentPreferences.autoPlayResponses },
                        set: { _ in preferencesManager.toggleAutoPlayResponses() }
                    ))
                    
                    Toggle("Reduce Motion", isOn: Binding(
                        get: { preferencesManager.currentPreferences.reducedMotion },
                        set: { _ in preferencesManager.toggleReducedMotion() }
                    ))
                }
                
                Section(header: Text("Test Voice")) {
                    Button("Play Sample") {
                        let params = preferencesManager.getAdjustedParameters(for: .neutral)
                        voiceService.voiceRate = params.rate
                        voiceService.voicePitch = params.pitch
                        voiceService.speak("Hello, I'm your EverNear companion. How are you feeling today?")
                    }
                    .accessibilityHint("Listen to voice with current settings")
                    
                    Button("Reset to Defaults") {
                        preferencesManager.resetToDefaults()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Voice Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    VoiceEnabledCompanionView()
}
