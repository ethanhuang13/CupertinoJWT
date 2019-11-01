// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CupertinoJWT",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "CupertinoJWT",
            targets: ["CupertinoJWT"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CupertinoJWT",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "CupertinoJWTTests",
            dependencies: ["CupertinoJWT"]),
    ],
    swiftLanguageVersions: [.v5]
)
