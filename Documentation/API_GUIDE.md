# EverNear API Guide

## Overview

This guide provides detailed documentation for EverNear's core components and their APIs. Each component is designed to work together to create a compassionate and supportive grief companion application.

## Core Components

### EmotionalAnalyzer

The EmotionalAnalyzer is responsible for understanding and responding to user emotions.

```swift
/// Analyzes text to determine emotional state
func analyzeEmotion(_ text: String) -> EmotionalState {
    // Returns: EmotionalState containing:
    // - primaryEmotion: The main detected emotion
    // - intensity: Emotion intensity (1-10)
    // - mixedEmotions: Additional detected emotions
}

/// Generates appropriate response based on emotional state
func generateResponse(to state: EmotionalState) -> String {
    // Returns: Compassionate response tailored to the emotional state
}
```

### MemoryManager

The MemoryManager handles the organization and retrieval of user memories.

```swift
/// Retrieves memories relevant to current emotional context
func getRelevantMemories(forPerson name: String, emotion: String) -> [Memory] {
    // Parameters:
    // - name: Name of the person being remembered
    // - emotion: Current emotional state
    // Returns: Array of relevant memories
}

/// Generates memory prompts based on emotional state
func getMemoryPrompt(forEmotion emotion: String) -> String {
    // Parameters:
    // - emotion: Current emotional state
    // Returns: Contextually appropriate memory prompt
}
```

### CheckInManager

The CheckInManager provides daily emotional check-ins and support.

```swift
/// Gets time-appropriate check-in prompt
func getCheckInPrompt() -> String {
    // Returns: Time-sensitive check-in prompt
    // Morning (6-11): Focus on starting the day
    // Afternoon (12-17): Mid-day emotional check
    // Evening (18-22): Reflection and processing
    // Late night (23-5): Extra support for difficult times
}

/// Provides self-care recommendations
func getSelfCareRecommendation(forEmotion emotion: String) -> String {
    // Parameters:
    // - emotion: Current emotional state
    // Returns: Tailored self-care activity suggestion
}

/// Analyzes emotional patterns over time
func analyzeEmotionalPattern() -> String {
    // Returns: Insight into emotional patterns over the past week
}
```

### SupportNetworkManager

The SupportNetworkManager handles support resources and connections.

```swift
/// Gets support recommendations based on emotional state
func getSupportRecommendation(forEmotion emotion: String, intensity: Int) -> String {
    // Parameters:
    // - emotion: Current emotional state
    // - intensity: Emotion intensity (1-10)
    // Returns: Appropriate support recommendation
    // Note: High intensity (>8) prioritizes immediate support
}

/// Manages trusted contacts
func addTrustedContact(_ contact: SupportContact)
func getAvailableContacts() -> [SupportContact]

/// Manages professional resources
func addProfessionalResource(_ resource: SupportResource)
func getResources(ofType type: ResourceType) -> [SupportResource]
```

### SpecialDatesManager

The SpecialDatesManager handles important dates and associated support.

```swift
/// Manages important dates
func addSpecialDate(_ date: SpecialDate)
func getUpcomingDates(withinDays days: Int = 30) -> [SpecialDate]

/// Provides support for special dates
func getSupportMessage(for date: SpecialDate) -> String {
    // Parameters:
    // - date: Special date information
    // Returns: Supportive message based on date type and proximity
}

func getSupportRecommendations(for date: SpecialDate) -> [String] {
    // Parameters:
    // - date: Special date information
    // Returns: Array of support recommendations based on support level
    // - Gentle: Basic check-in and reflection
    // - Moderate: Additional support options
    // - Intensive: Comprehensive support plan
}
```

## UI Components

### DailyCheckInView

A SwiftUI view for daily emotional check-ins.

Key Features:
- Emotion selection with visual indicators
- Intensity tracking slider
- Activity logging
- Notes and reflection
- Quick access to support resources

### SupportResourcesView

A SwiftUI view for accessing support resources.

Key Features:
- Contextual support recommendations
- Available contacts display
- Professional resource cards
- Quick action buttons for reaching out

## Best Practices

1. **Emotional Intelligence**
   - Always validate user emotions
   - Provide appropriate support based on emotion intensity
   - Consider conversation history and context

2. **Memory Handling**
   - Retrieve memories sensitively based on emotional state
   - Provide gentle prompts for memory sharing
   - Respect user privacy preferences

3. **Support Network**
   - Prioritize immediate support for high-intensity emotions
   - Consider time zones for contact availability
   - Provide multiple support options

4. **Special Dates**
   - Start support preparation before significant dates
   - Adjust support level based on date type and user needs
   - Use appropriate notification timing

## Error Handling

Each component includes robust error handling:

```swift
enum EverNearError: Error {
    case invalidEmotionalState
    case memoryNotFound
    case supportResourceUnavailable
    case dateConflict
    case privacyViolation
}
```

Handle errors gracefully and provide appropriate user feedback.

## Privacy and Security

All components adhere to strict privacy and security guidelines:

1. **Data Protection**
   - End-to-end encryption for sensitive data
   - Local storage with encryption
   - Biometric authentication

2. **Privacy Controls**
   - User consent for data sharing
   - Screenshot protection
   - Configurable privacy settings

3. **Support Network Security**
   - Verified professional resources
   - Trusted contact verification
   - Secure communication channels

## Testing

Each component includes comprehensive unit tests:

```swift
class MemoryAndSupportTests: XCTestCase {
    func testMemoryRetrieval()
    func testMemoryPrompts()
    func testCheckInAnalysis()
    func testSelfCareRecommendations()
    func testSupportRecommendations()
    func testAvailableContacts()
}
```

Run tests regularly to ensure component reliability.
