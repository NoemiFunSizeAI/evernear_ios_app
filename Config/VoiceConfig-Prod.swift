import Foundation

enum VoiceConfig {
    static let version = "0.4.0"
    static let environment = "production"
    
    struct Voice {
        static let defaultRate: Float = 0.5
        static let defaultPitch: Float = 1.0
        static let useEmotionalAdjustment = true
        static let maxRecordingDuration: TimeInterval = 300
        static let audioQuality = "high"
    }
    
    struct API {
        static let leopardEndpoint = "https://api.leopard.ai"
        static let useLocalModel = false
        static let enableDebugLogging = false
    }
    
    struct Storage {
        static let voiceDataPath = "\(NSHomeDirectory())/Library/Application Support/EverNear/VoiceData"
        static let maxStorageSize: Int64 = 10_000_000_000 // 10GB
        static let keepRecordingsDays = 90
    }
    
    struct Performance {
        static let maxConcurrentRequests = 20
        static let memoryWarningThreshold: Int64 = 500_000_000 // 500MB
        static let enableProfiling = false
    }
}
