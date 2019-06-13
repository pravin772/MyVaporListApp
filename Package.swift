// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Lists",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "3.0.0")
        
    ],
    targets: [
        .target(name: "App", dependencies: ["Leaf", "Vapor", "FluentSQLite"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

