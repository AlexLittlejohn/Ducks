// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Ducks",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
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
