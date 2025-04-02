import Foundation

enum VoiceConfig {
    static let version = "0.4.0"
    static let environment = "staging"
    
    struct Voice {
        static let defaultRate: Float = 0.5
        static let defaultPitch: Float = 1.0
        static let useEmotionalAdjustment = true
        static let maxRecordingDuration: TimeInterval = 120
        static let audioQuality = "high"
    }
    
    struct API {
        static let leopardEndpoint = "https://staging-api.leopard.ai"
        static let useLocalModel = false
        static let enableDebugLogging = true
    }
    
    struct Storage {
        static let voiceDataPath = "\(NSHomeDirectory())/Library/Application Support/EverNear/VoiceData-staging"
        static let maxStorageSize: Int64 = 5_000_000_000 // 5GB
        static let keepRecordingsDays = 30
    }
    
    struct Performance {
        static let maxConcurrentRequests = 10
        static let memoryWarningThreshold: Int64 = 200_000_000 // 200MB
        static let enableProfiling = true
    }
}
