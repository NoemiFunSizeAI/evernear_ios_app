// EverNear iOS App - README.md
# EverNear iOS Application

*"Keeping cherished moments close to your heart"*

Developed by Noemi Reyes

## Overview

EverNear is a compassionate mobile application designed to support individuals navigating the complex journey of grief. It provides a private, interactive digital space where users can share memories, emotions, and thoughts about their lost loved ones. The app serves as a listening companion that collects and organizes shared moments, providing comfort through reflection and digital companionship.

## Key Features

1. **Memory Collection & Reflection**
   - Log memories, thoughts, or feelings related to lost loved ones
   - Categorize memories (Magical Moments, Heartfelt Feelings, Life Updates, Difficult Times, Shared Wins)
   - Add photos, audio recordings, and location data to memories

2. **AI Companion**
   - Emotionally intelligent AI with voice interaction
   - Voice-enabled conversations with emotion detection
   - Personalized responses that adapt to emotional state
   - Voice preferences with accessibility options
   - Memory-aware conversation context

3. **Privacy & Security**
   - End-to-end encryption for sensitive content
   - Biometric authentication (Face ID/Touch ID)
   - Screenshot protection
   - Customizable privacy settings

4. **Personalized Experience**
   - Daily check-ins and gentle reminders
   - Memory prompts based on emotional state
   - Ability to revisit memories based on emotional needs

5. **Support Network Integration**
   - Optional sharing with trusted contacts
   - Resources for professional support

## Technical Architecture

EverNear is built using Swift for iOS with a focus on privacy, security, and emotional intelligence. The app follows the Model-View-Controller (MVC) architecture pattern and includes the following components:

### Models
- Data models for memories, conversations, user profiles, and settings
- Services for memory management, AI companion, and emotional analysis
- Security and privacy management

### Controllers
- View controllers for all app screens and interactions
- Navigation and tab bar controllers for app flow

### Helpers
- Security and encryption utilities
- Privacy management
- Data persistence

## Getting Started

### Prerequisites
- Xcode 13.0 or later
- iOS 15.0 or later
- Swift 5.5 or later

### Installation

#### Prerequisites
- Xcode 13.0 or later
- iOS 15.0 or later
- Swift 5.5 or later
- CocoaPods (optional, for additional dependencies)

#### Setting up in Xcode
1. Clone the repository
2. Create new Xcode project:
   - Open Xcode
   - File > New > Project
   - Choose iOS > App
   - Set:
     - Product Name: "EverNear"
     - Team: Your development team
     - Organization Identifier: "ai.evernear"
     - Interface: SwiftUI
     - Language: Swift
     - Include Tests: Yes

3. Set up build configurations:
   - Select project in navigator
   - Select "EverNear" target
   - Add "Staging" configuration:
     - Click "+" under Configurations
     - Duplicate "Release" configuration
     - Name it "Staging"
   - Configure each environment:
     - Debug → VoiceConfig-Dev.swift
     - Staging → VoiceConfig-Staging.swift
     - Release → VoiceConfig-Prod.swift

4. Add dependencies:
   - File > Add Packages
   - Add each URL:
     ```
     https://github.com/Picovoice/Leopard-iOS
     https://github.com/AudioKit/AudioKit
     https://github.com/apple/swift-algorithms
     ```

5. Create schemes:
   - Product > Scheme > Manage Schemes
   - Create three schemes:
     - EverNear-Debug (Debug configuration)
     - EverNear-Staging (Staging configuration)
     - EverNear-Release (Release configuration)

6. Verify Info.plist settings:
   ```xml
   <key>NSMicrophoneUsageDescription</key>
   <string>EverNear needs access to your microphone for voice recording.</string>
   <key>UILaunchStoryboardName</key>
   <string>LaunchScreen</string>
   <key>UIRequiredDeviceCapabilities</key>
   <array>
       <string>armv7</string>
   </array>
   <key>UISupportedInterfaceOrientations</key>
   <array>
       <string>UIInterfaceOrientationPortrait</string>
   </array>
   ```

7. Build and run on simulator or device

### Troubleshooting Guide

#### Common Issues

1. **Build Errors**
   - *Issue*: Missing dependencies
   - *Solution*: Ensure all SPM packages are properly added and resolved (File > Packages > Reset Package Caches)

2. **Voice Recognition Issues**
   - *Issue*: Microphone permission denied
   - *Solution*: Check Info.plist for NSMicrophoneUsageDescription and ensure permission is granted in device settings

3. **Configuration Errors**
   - *Issue*: Wrong environment configuration
   - *Solution*: Verify scheme configuration matches intended environment (Debug/Staging/Release)

4. **Memory Management**
   - *Issue*: App crashes with memory warning
   - *Solution*: Check VoiceConfig settings for proper memory thresholds

5. **Scheme Selection**
   - *Issue*: Wrong environment variables
   - *Solution*: Ensure correct scheme is selected for intended environment

#### Environment-Specific Issues

1. **Debug Environment**
   - Uses VoiceConfig-Dev.swift
   - Local model enabled
   - Debug logging enabled
   - Memory warnings at 100MB

2. **Staging Environment**
   - Uses VoiceConfig-Staging.swift
   - Remote staging API
   - Limited debug logging
   - Memory warnings at 150MB

3. **Production Environment**
   - Uses VoiceConfig-Prod.swift
   - Production API endpoints
   - No debug logging
   - Memory warnings at 200MB

#### Getting Help

1. Check the [Issues](https://github.com/NoemiFunSizeAI/evernear_ios_app/issues) page
2. Review error logs in Xcode's Console
3. Contact the development team for support

## Project Structure

```
EverNear/
├── Models/
│   ├── EmotionalAnalysis.swift      # Emotional state analysis
│   ├── MockAIService.swift          # AI companion service
│   ├── ConversationMemory.swift     # Conversation context management
│   ├── MemoryManager.swift          # Memory organization
│   ├── DailyCheckIn.swift           # Check-in functionality
│   ├── SupportNetwork.swift         # Support network integration
│   └── SpecialDates.swift           # Important dates management
├── Services/
│   ├── VoiceInteractionService.swift # Speech synthesis and recognition
│   ├── VoiceEmotionAnalyzer.swift   # Real-time emotion detection
│   ├── ConversationFlowManager.swift # Context-aware responses
│   └── VoicePreferencesManager.swift # Voice settings management
├── Controllers/
│   ├── OnboardingViewController.swift
│   ├── HomeViewController.swift
│   ├── MemoriesViewController.swift
│   ├── CreateMemoryViewController.swift
│   ├── AICompanionViewController.swift
│   ├── MoreViewController.swift
│   └── PrivacySettingsViewController.swift
├── Helpers/
│   ├── SecurityManager.swift
│   └── PrivacyManager.swift
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
```

## Core Components

### Voice Interaction System
- **Voice Recognition**: Real-time speech recognition with emotion detection
- **Natural Speech**: High-quality voice synthesis with emotional adaptation
- **Conversation Flow**: Context-aware responses with memory integration
- **Voice Preferences**: Customizable voice settings with accessibility options

### Emotional Intelligence System
- **Emotion Analysis**: Sophisticated analysis of voice and text with support for grief-specific states
- **Context-Aware Responses**: AI responses that adapt voice and content to emotional state
- **Voice Metrics**: Real-time analysis of pitch, volume, and speaking patterns
- **Memory Integration**: Voice-based memory sharing and retrieval
- **Memory Integration**: Smart retrieval of relevant memories based on emotional context

### Daily Check-in System
- **Time-Aware Prompts**: Context-sensitive check-in prompts throughout the day
- **Emotional Tracking**: Comprehensive tracking of emotional patterns
- **Self-Care Suggestions**: Personalized self-care recommendations based on emotional state

### Support Network Integration
- **Trusted Contacts**: Management of personal support network
- **Professional Resources**: Access to various types of professional support
- **Smart Recommendations**: Context-aware support suggestions based on emotional state

### Special Dates Management
- **Important Dates**: Tracking of birthdays, anniversaries, and other significant dates
- **Proactive Support**: Customized support before and during significant dates
- **Smart Notifications**: Support level-based notification scheduling

## Testing

The application includes comprehensive unit tests for all components:

```swift
class MemoryAndSupportTests: XCTestCase {
    // Memory Management Tests
    func testMemoryRetrieval()
    func testMemoryPrompts()
    
    // Check-in System Tests
    func testCheckInAnalysis()
    func testSelfCareRecommendations()
    
    // Support Network Tests
    func testSupportRecommendations()
    func testAvailableContacts()
}
```

## API Documentation

### EmotionalAnalysis
```swift
class EmotionalAnalyzer {
    /// Analyzes text input to determine emotional state
    func analyzeEmotion(_ text: String) -> EmotionalState
    
    /// Generates appropriate response based on emotional state
    func generateResponse(to state: EmotionalState) -> String
}
```

### MemoryManager
```swift
class MemoryManager {
    /// Retrieves memories relevant to current emotional context
    func getRelevantMemories(forPerson: String, emotion: String) -> [Memory]
    
    /// Generates memory prompts based on emotional state
    func getMemoryPrompt(forEmotion: String) -> String
}
```

### CheckInManager
```swift
class CheckInManager {
    /// Gets time-appropriate check-in prompt
    func getCheckInPrompt() -> String
    
    /// Provides self-care recommendations
    func getSelfCareRecommendation(forEmotion: String) -> String
    
    /// Analyzes emotional patterns over time
    func analyzeEmotionalPattern() -> String
}
```

### SupportNetworkManager
```swift
class SupportNetworkManager {
    /// Gets support recommendations based on emotional state
    func getSupportRecommendation(forEmotion: String, intensity: Int) -> String
    
    /// Manages trusted contacts
    func addTrustedContact(_ contact: SupportContact)
    func getAvailableContacts() -> [SupportContact]
    
    /// Manages professional resources
    func addProfessionalResource(_ resource: SupportResource)
    func getResources(ofType: ResourceType) -> [SupportResource]
}
```

### SpecialDatesManager
```swift
class SpecialDatesManager {
    /// Manages important dates
    func addSpecialDate(_ date: SpecialDate)
    func getUpcomingDates(withinDays: Int) -> [SpecialDate]
    
    /// Provides support for special dates
    func getSupportMessage(for date: SpecialDate) -> String
    func getSupportRecommendations(for date: SpecialDate) -> [String]
    
    /// Handles notifications
    func scheduleNotifications()
}
```

## UI Components

### DailyCheckInView
- Emotion selection with visual indicators
- Intensity slider
- Activity tracking
- Notes and reflection
- Self-care and support access

### SupportResourcesView
- Recommendation cards
- Available contacts section
- Professional resources section
- Quick action buttons for reaching out

## Security and Privacy

EverNear maintains strict security and privacy standards:

- End-to-end encryption for all sensitive data
- Biometric authentication
- Local data storage with encryption
- Screenshot protection
- Privacy-first design principles
- SecurityManager tests

Run tests in Xcode using Cmd+U or through the Test Navigator.

## Future Enhancements

1. **Android Version**
   - Develop an Android version of the app for wider accessibility

2. **Web Extension**
   - Create a web version for desktop access

3. **Advanced AI Features**
   - Implement more sophisticated emotional analysis
   - Add voice interaction capabilities

4. **Community Features**
   - Optional grief support groups
   - Shared memorial spaces (with strict privacy controls)

5. **Integration with Professional Support**
   - Direct connections to grief counselors
   - Integration with telehealth services

## Privacy Commitment

EverNear is built with privacy as a fundamental principle. All user data is stored locally on the device by default, with optional encrypted cloud backup. The app does not share any data with third parties without explicit user consent.

## Support

For support, feature requests, or bug reports, please contact support@evernear.app

---

© 2025 EverNear. All rights reserved. Developed by Noemi Reyes
