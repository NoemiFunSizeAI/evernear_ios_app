// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "EverNear",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "EverNear",
            targets: ["EverNear"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Picovoice/Leopard-iOS", from: "2.0.0"),  // Speech-to-text
        .package(url: "https://github.com/AudioKit/AudioKit", from: "5.0.0"),  // Audio processing
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0")  // Signal processing
    ],
    targets: [
        .target(
            name: "EverNear",
            dependencies: [
                "Leopard-iOS",
                "AudioKit",
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "EverNear"),
        .executableTarget(
            name: "TestAI",
            dependencies: ["EverNear"],
            path: "Scripts",
            sources: ["test_mock_ai.swift"])
    ]
)
