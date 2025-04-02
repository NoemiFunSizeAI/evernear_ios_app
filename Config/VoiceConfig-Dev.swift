import Foundation

enum VoiceConfig {
    static let version = "0.4.0"
    static let environment = "development"
    
    struct Voice {
        static let defaultRate: Float = 0.5
        static let defaultPitch: Float = 1.0
        static let useEmotionalAdjustment = true
        static let maxRecordingDuration: TimeInterval = 60
        static let audioQuality = "high"
    }
    
    struct API {
        static let leopardEndpoint = "https://dev-api.leopard.ai"
        static let useLocalModel = true
        static let enableDebugLogging = true
    }
    
    struct Storage {
        static let voiceDataPath = "\(NSHomeDirectory())/Library/Application Support/EverNear/VoiceData-dev"
        static let maxStorageSize: Int64 = 1_000_000_000 // 1GB
        static let keepRecordingsDays = 7
    }
    
    struct Performance {
        static let maxConcurrentRequests = 5
        static let memoryWarningThreshold: Int64 = 100_000_000 // 100MB
        static let enableProfiling = true
    }
}
