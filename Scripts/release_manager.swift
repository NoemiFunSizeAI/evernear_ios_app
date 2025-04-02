import Foundation

/// Release Manager for EverNear
struct ReleaseManager {
    // MARK: - Types
    
    enum ReleaseType: String {
        case major, minor, patch, hotfix
    }
    
    struct Version {
        let major: Int
        let minor: Int
        let patch: Int
        let build: Int
        
        var string: String { "\(major).\(minor).\(patch)" }
        var fullString: String { "\(string) (\(build))" }
    }
    
    // MARK: - Properties
    
    private let fileManager = FileManager.default
    private let currentDate = Date()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Public Methods
    
    func prepareRelease(type: ReleaseType) throws {
        print("🚀 Preparing \(type.rawValue) release...")
        
        // 1. Get current version
        let currentVersion = try getCurrentVersion()
        let newVersion = incrementVersion(currentVersion, type: type)
        print("📦 Version: \(currentVersion.string) → \(newVersion.string)")
        
        // 2. Update version files
        try updateVersionFiles(to: newVersion)
        
        // 3. Update changelog
        try updateChangelog(for: newVersion)
        
        // 4. Update voice configuration
        try updateVoiceConfigs(to: newVersion)
        
        // 5. Generate release notes
        try generateReleaseNotes(for: newVersion)
        
        // 6. Create release branch
        createReleaseBranch(for: newVersion)
        
        print("✅ Release preparation complete!")
        print("Next steps:")
        print("1. Review changes in release branch")
        print("2. Run: fastlane deploy_staging")
        print("3. After QA approval, run: fastlane deploy_prod")
    }
    
    // MARK: - Private Methods
    
    private func getCurrentVersion() throws -> Version {
        let infoPlist = try String(contentsOfFile: "EverNear/Info.plist")
        // Parse version from Info.plist (simplified for example)
        return Version(major: 0, minor: 4, patch: 0, build: 1)
    }
    
    private func incrementVersion(_ version: Version, type: ReleaseType) -> Version {
        switch type {
        case .major:
            return Version(major: version.major + 1, minor: 0, patch: 0, build: version.build + 1)
        case .minor:
            return Version(major: version.major, minor: version.minor + 1, patch: 0, build: version.build + 1)
        case .patch:
            return Version(major: version.major, minor: version.minor, patch: version.patch + 1, build: version.build + 1)
        case .hotfix:
            return Version(major: version.major, minor: version.minor, patch: version.patch + 1, build: version.build + 1)
        }
    }
    
    private func updateVersionFiles(to version: Version) throws {
        // Update Info.plist
        try updateInfoPlist(to: version)
        
        // Update Package.swift
        try updatePackageSwift(to: version)
        
        // Update build number
        try updateBuildNumber(to: version.build)
    }
    
    private func updateChangelog(for version: Version) throws {
        let changelogPath = "CHANGELOG.md"
        var changelog = try String(contentsOfFile: changelogPath)
        
        // Get git log since last release
        let gitLog = try shell("git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:'- %s'")
        
        // Group changes by type
        var features: [String] = []
        var fixes: [String] = []
        var voiceChanges: [String] = []
        
        gitLog.split(separator: "\n").forEach { line in
            let commit = String(line)
            if commit.contains("feat:") { features.append(commit) }
            else if commit.contains("fix:") { fixes.append(commit) }
            else if commit.contains("voice:") { voiceChanges.append(commit) }
        }
        
        // Create new changelog entry
        let entry = """
        ## [\(version.string)] - \(dateFormatter.string(from: currentDate))
        
        ### Added
        \(features.joined(separator: "\n"))
        
        ### Fixed
        \(fixes.joined(separator: "\n"))
        
        ### Voice Interaction
        \(voiceChanges.joined(separator: "\n"))
        
        """
        
        // Insert at top of changelog
        changelog = entry + "\n" + changelog
        try changelog.write(toFile: changelogPath, atomically: true, encoding: .utf8)
    }
    
    private func updateVoiceConfigs(to version: Version) throws {
        let environments = ["Dev", "Staging", "Prod"]
        for env in environments {
            let configPath = "Config/VoiceConfig-\(env).swift"
            var config = try String(contentsOfFile: configPath)
            
            // Update version
            let versionRegex = try NSRegularExpression(pattern: "static let version = \".*\"")
            config = versionRegex.stringByReplacingMatches(
                in: config,
                range: NSRange(config.startIndex..., in: config),
                withTemplate: "static let version = \"\(version.string)\""
            )
            
            try config.write(toFile: configPath, atomically: true, encoding: .utf8)
        }
    }
    
    private func generateReleaseNotes(for version: Version) throws {
        let notesPath = "fastlane/metadata/en-US/release_notes.txt"
        let notes = try generateReleaseNotesContent(for: version)
        try notes.write(toFile: notesPath, atomically: true, encoding: .utf8)
    }
    
    private func createReleaseBranch(for version: Version) {
        let branchName = "release/\(version.string)"
        _ = try? shell("git checkout -b \(branchName)")
        _ = try? shell("git add .")
        _ = try? shell("git commit -m \"chore: Prepare release \(version.string)\"")
    }
    
    private func generateReleaseNotesContent(for version: Version) throws -> String {
        // Get commits since last tag
        let commits = try shell("git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:'%s'")
        
        // Filter and format relevant commits
        let relevantCommits = commits
            .split(separator: "\n")
            .filter { commit in
                let str = String(commit)
                return str.hasPrefix("feat:") || str.hasPrefix("fix:") || str.hasPrefix("voice:")
            }
            .map { commit -> String in
                let str = String(commit)
                return "• " + str.replacingOccurrences(of: "^(feat|fix|voice): ", with: "", options: .regularExpression)
            }
        
        // Generate user-friendly notes
        return """
        What's New in \(version.string):
        
        \(relevantCommits.joined(separator: "\n"))
        
        Thank you for using EverNear! 💜
        """
    }
    
    private func shell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        
        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}

// MARK: - Script Execution

if CommandLine.arguments.count != 2 {
    print("Usage: swift release_manager.swift <major|minor|patch|hotfix>")
    exit(1)
}

let releaseType = CommandLine.arguments[1]
guard let type = ReleaseManager.ReleaseType(rawValue: releaseType) else {
    print("Invalid release type. Use: major, minor, patch, or hotfix")
    exit(1)
}

do {
    let manager = ReleaseManager()
    try manager.prepareRelease(type: type)
} catch {
    print("❌ Error: \(error)")
    exit(1)
}
