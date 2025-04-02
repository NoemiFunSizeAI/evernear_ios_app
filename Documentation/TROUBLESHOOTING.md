# EverNear Troubleshooting Guide

## Common Issues and Solutions

### 1. Emotional Analysis Issues

#### Problem: Incorrect Emotion Detection
```swift
// Symptoms:
// - AI responses don't match user's emotional state
// - Unexpected emotional intensity values
// - Missing mixed emotions
```

**Solutions:**
1. Check input text preprocessing:
```swift
func preprocessText(_ text: String) -> String {
    return text.trimmingCharacters(in: .whitespacesAndNewlines)
             .lowercased()
}
```

2. Verify emotional state calculation:
```swift
func verifyEmotionalState(_ state: EmotionalState) -> Bool {
    guard state.intensity >= 1 && state.intensity <= 10 else {
        Logger.log("Invalid intensity: \(state.intensity)")
        return false
    }
    return true
}
```

3. Debug mixed emotions detection:
```swift
func debugEmotionAnalysis(_ text: String) {
    let words = text.components(separatedBy: .whitespaces)
    let emotionalWords = words.filter { EmotionalAnalyzer.emotionKeywords.contains($0) }
    Logger.log("Emotional words found: \(emotionalWords)")
}
```

### 2. Memory Management Issues

#### Problem: Memory Retrieval Failures
```swift
// Symptoms:
// - Memories not showing up in relevant contexts
// - Incorrect memory categorization
// - Missing memory metadata
```

**Solutions:**
1. Check memory indexing:
```swift
func verifyMemoryIndex() {
    let memories = MemoryManager.shared.getAllMemories()
    for memory in memories {
        guard memory.id != nil,
              memory.category != nil,
              !memory.content.isEmpty else {
            Logger.log("Invalid memory found: \(memory)")
            continue
        }
    }
}
```

2. Debug memory retrieval:
```swift
func debugMemoryRetrieval(forPerson name: String, emotion: String) {
    let relevantMemories = MemoryManager.shared.getRelevantMemories(
        forPerson: name,
        emotion: emotion
    )
    Logger.log("""
        Memory retrieval debug:
        - Person: \(name)
        - Emotion: \(emotion)
        - Found memories: \(relevantMemories.count)
        - Categories: \(Set(relevantMemories.map { $0.category }))
        """)
}
```

### 3. Support Network Issues

#### Problem: Support Resource Availability
```swift
// Symptoms:
// - Unable to reach contacts
// - Missing professional resources
// - Incorrect availability times
```

**Solutions:**
1. Verify contact availability:
```swift
func debugContactAvailability() {
    let contacts = SupportNetworkManager.shared.getAllTrustedContacts()
    let calendar = Calendar.current
    let currentHour = calendar.component(.hour, from: Date())
    
    for contact in contacts {
        let isAvailable = contact.availabilityHours.contains { range in
            range.contains(currentHour)
        }
        Logger.log("""
            Contact availability check:
            - Name: \(contact.name)
            - Current hour: \(currentHour)
            - Available: \(isAvailable)
            - Hours: \(contact.availabilityHours)
            """)
    }
}
```

2. Check resource validity:
```swift
func verifyResources() {
    let resources = SupportNetworkManager.shared.getAllResources()
    for resource in resources {
        guard let url = resource.website,
              UIApplication.shared.canOpenURL(url) else {
            Logger.log("Invalid resource URL: \(resource.name)")
            continue
        }
    }
}
```

### 4. Notification Issues

#### Problem: Missing or Delayed Notifications
```swift
// Symptoms:
// - Check-in reminders not appearing
// - Special date notifications missing
// - Support notifications delayed
```

**Solutions:**
1. Debug notification scheduling:
```swift
func debugNotificationSchedule() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        Logger.log("""
            Pending notifications:
            Total count: \(requests.count)
            Next 24 hours: \(requests.filter {
                guard let trigger = $0.trigger as? UNCalendarNotificationTrigger,
                      let date = trigger.nextTriggerDate() else { return false }
                return date <= Date().addingTimeInterval(86400)
            }.count)
            """)
    }
}
```

2. Verify notification permissions:
```swift
func verifyNotificationAccess() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else {
            Logger.log("Notifications not authorized")
            return
        }
        
        let enabledTypes: [String] = [
            settings.alertSetting == .enabled ? "alerts" : nil,
            settings.soundSetting == .enabled ? "sounds" : nil,
            settings.badgeSetting == .enabled ? "badges" : nil
        ].compactMap { $0 }
        
        Logger.log("Enabled notification types: \(enabledTypes)")
    }
}
```

### 5. Privacy and Security Issues

#### Problem: Security Verification Failures
```swift
// Symptoms:
// - Authentication failures
// - Encryption errors
// - Privacy setting conflicts
```

**Solutions:**
1. Check authentication status:
```swift
func debugAuthentication() {
    let context = LAContext()
    var error: NSError?
    
    guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
        Logger.log("Authentication not available: \(error?.localizedDescription ?? "Unknown error")")
        return
    }
    
    Logger.log("""
        Authentication status:
        - Biometry type: \(context.biometryType.rawValue)
        - Biometry available: \(context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil))
        """)
}
```

2. Verify encryption:
```swift
func verifyEncryption() {
    guard let keychain = try? KeychainAccess(),
          keychain.containsEncryptionKey else {
        Logger.log("Encryption key not found")
        return
    }
    
    Logger.log("Encryption status: Active")
}
```

## Performance Optimization

### Memory Usage
```swift
func checkMemoryUsage() {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
    
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_,
                     task_flavor_t(MACH_TASK_BASIC_INFO),
                     $0,
                     &count)
        }
    }
    
    if kerr == KERN_SUCCESS {
        let usedMB = Double(info.resident_size) / 1024.0 / 1024.0
        Logger.log("Memory used: \(usedMB)MB")
    }
}
```

### Database Performance
```swift
func optimizeDatabaseAccess() {
    // Implement caching for frequently accessed data
    let cache = NSCache<NSString, AnyObject>()
    cache.countLimit = 100
    cache.totalCostLimit = 10 * 1024 * 1024 // 10MB
    
    // Monitor database access patterns
    Logger.log("Database access patterns in last hour:")
    Logger.log("- Memory retrievals: \(DatabaseMetrics.memoryRetrievals)")
    Logger.log("- Support lookups: \(DatabaseMetrics.supportLookups)")
    Logger.log("- Emotion analyses: \(DatabaseMetrics.emotionAnalyses)")
}
```

## Logging and Monitoring

### Debug Logging
```swift
class Logger {
    static func log(_ message: String,
                   file: String = #file,
                   function: String = #function,
                   line: Int = #line) {
        #if DEBUG
        let timestamp = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .none,
            timeStyle: .medium
        )
        print("[\(timestamp)] \(file):\(line) - \(message)")
        #endif
    }
}
```

### Performance Monitoring
```swift
func monitorPerformance() {
    let metrics = PerformanceMetrics.shared
    
    metrics.track("emotion_analysis") { duration in
        Logger.log("Emotion analysis average duration: \(duration)ms")
    }
    
    metrics.track("memory_retrieval") { duration in
        Logger.log("Memory retrieval average duration: \(duration)ms")
    }
}
```

## Best Practices

1. **Regular Testing**
   - Run unit tests frequently
   - Test with various emotional inputs
   - Verify security measures

2. **Performance Monitoring**
   - Track memory usage
   - Monitor response times
   - Check database efficiency

3. **Error Handling**
   - Implement comprehensive logging
   - Provide user-friendly error messages
   - Handle edge cases gracefully

4. **Security Verification**
   - Regular security audits
   - Encryption verification
   - Privacy settings check
