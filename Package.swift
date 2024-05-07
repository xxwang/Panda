// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Panda",
    platforms: [
        .iOS(.v12),
        .macOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5),
    ],
    products: [
        .library(name: "Panda", targets: ["Panda"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Panda", dependencies: [], path: "Sources"),
    ]
)
