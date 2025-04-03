#!/usr/bin/env swift

import Foundation

// MARK: - Configuration
let projectName = "EverNear"
let organizationName = "EverNear"
let bundleIdentifier = "ai.evernear.app"

// MARK: - Build Configurations
enum BuildConfiguration: String {
    case debug = "Debug"
    case staging = "Staging"
    case release = "Release"
    
    var configFile: String {
        switch self {
        case .debug: return "VoiceConfig-Dev.swift"
        case .staging: return "VoiceConfig-Staging.swift"
        case .release: return "VoiceConfig-Prod.swift"
        }
    }
}

// MARK: - Directory Structure
let baseDir = FileManager.default.currentDirectoryPath
let sourcesDir = "\(baseDir)/EverNear"
let configDir = "\(baseDir)/Config"
let scriptsDir = "\(baseDir)/Scripts"
let testsDir = "\(baseDir)/EverNearTests"

// MARK: - Xcode Project Structure
struct XcodeProject {
    static func createDirectoryStructure() throws {
        let directories = [
            "\(projectName).xcodeproj",
            "\(projectName)/App",
            "\(projectName)/Sources",
            "\(projectName)/Resources",
            "\(projectName)/Config"
        ]
        
        try directories.forEach { dir in
            try FileManager.default.createDirectory(
                atPath: dir,
                withIntermediateDirectories: true
            )
        }
    }
    
    static func copySourceFiles() throws {
        let fm = FileManager.default
        
        func copyDirectory(from source: String, to destination: String) throws {
            if fm.fileExists(atPath: destination) {
                try fm.removeItem(atPath: destination)
            }
            
            try fm.createDirectory(atPath: destination, withIntermediateDirectories: true)
            
            let contents = try fm.contentsOfDirectory(atPath: source)
            for item in contents {
                let sourcePath = (source as NSString).appendingPathComponent(item)
                let destPath = (destination as NSString).appendingPathComponent(item)
                try fm.copyItem(atPath: sourcePath, toPath: destPath)
            }
        }
        
        // Copy source files
        try copyDirectory(
            from: sourcesDir,
            to: "\(projectName)/Sources/EverNear"
        )
        
        // Copy config files
        try copyDirectory(
            from: configDir,
            to: "\(projectName)/Config"
        )
        
        // Copy tests
        try copyDirectory(
            from: testsDir,
            to: "\(projectName)Tests"
        )
    }
    
    static func createAppDelegate() throws {
        let appDelegate = """
        import UIKit
        
        @main
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?
            
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                return true
            }
        }
        """
        
        try appDelegate.write(
            toFile: "\(projectName)/App/AppDelegate.swift",
            atomically: true,
            encoding: .utf8
        )
    }
    
    static func createBuildConfigurations() throws {
        for config in [BuildConfiguration.debug, .staging, .release] {
            let configContent = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
                <key>CONFIGURATION</key>
                <string>\(config.rawValue)</string>
                <key>VOICE_CONFIG_FILE</key>
                <string>\(config.configFile)</string>
            </dict>
            </plist>
            """
            
            try configContent.write(
                toFile: "\(projectName)/Config/\(config.rawValue).xcconfig",
                atomically: true,
                encoding: .utf8
            )
        }
    }
    
    static func createInfoPlist() throws {
        let infoPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>CFBundleDevelopmentRegion</key>
            <string>$(DEVELOPMENT_LANGUAGE)</string>
            <key>CFBundleExecutable</key>
            <string>$(EXECUTABLE_NAME)</string>
            <key>CFBundleIdentifier</key>
            <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
            <key>CFBundleInfoDictionaryVersion</key>
            <string>6.0</string>
            <key>CFBundleName</key>
            <string>$(PRODUCT_NAME)</string>
            <key>CFBundlePackageType</key>
            <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
            <key>CFBundleShortVersionString</key>
            <string>1.0</string>
            <key>CFBundleVersion</key>
            <string>1</string>
            <key>LSRequiresIPhoneOS</key>
            <true/>
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
        </dict>
        </plist>
        """
        
        try infoPlist.write(
            toFile: "\(projectName)/Info.plist",
            atomically: true,
            encoding: .utf8
        )
    }
}

// MARK: - Main
do {
    print("📱 Setting up Xcode project structure...")
    try XcodeProject.createDirectoryStructure()
    
    print("📂 Copying source files...")
    try XcodeProject.copySourceFiles()
    
    print("📝 Creating AppDelegate...")
    try XcodeProject.createAppDelegate()
    
    print("📄 Creating Info.plist...")
    try XcodeProject.createInfoPlist()
    
    print("⚙️ Creating build configurations...")
    try XcodeProject.createBuildConfigurations()
    
    print("✅ Setup complete! Next steps:")
    print("1. Open Xcode")
    print("2. Create new project named '\(projectName)' with organization '\(organizationName)'")
    print("3. Choose 'Create Git repository' if needed")
    print("4. Replace the generated project structure with the one created by this script")
    print("5. Add the SPM dependencies from Package.swift")
    print("6. Build and run!")
} catch {
    print("❌ Error: \(error.localizedDescription)")
    exit(1)
}
