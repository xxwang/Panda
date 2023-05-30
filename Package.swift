// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Panda",
    platforms: [
        .iOS(.v13),
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
        .testTarget(name: "PandaTests", dependencies: ["Panda"]),
    ]
)
