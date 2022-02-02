// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Ducks",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .tvOS(.v12),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Ducks",
            targets: ["Ducks"]),
    ],
    targets: [
        .target(
            name: "Ducks",
            dependencies: []),
        .testTarget(
            name: "DucksTests",
            dependencies: ["Ducks"]),
    ]
)
