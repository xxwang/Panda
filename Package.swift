// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "PandaKit",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(name: "PandaKit", targets: ["Sources"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Sources", dependencies: [], path: "Sources"),
    ]
)
