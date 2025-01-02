// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BubblesLayout",
    platforms: [.iOS(.v16), .macCatalyst(.v16), .macOS(.v13)], // TODO: Add support if possible, .tvOS(.v16), .visionOS(.v1)],
    products: [
        .library(
            name: "BubblesLayout",
            targets: ["BubblesLayout"]
        )
    ],
    targets: [
        .target(
            name: "BubblesLayout"
        )
    ]
)
