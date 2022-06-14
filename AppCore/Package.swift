// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AppCore", targets: ["AppCore"]),
        .library(name: "Helpers", targets: ["Helpers"]),
        .library(name: "Library", targets: ["Library"]),
        .library(name: "Feed", targets: ["Feed"]),
        .library(name: "Routing", targets: ["Routing"])
    ],
    dependencies: [],
    targets: [
        .target(name: "AppCore", dependencies: ["Library"]),
        .testTarget(name: "AppCoreTests", dependencies: ["AppCore"]),
        .target(name: "Helpers", dependencies: []),
        .target(name: "Library", dependencies: []),
        .target(name: "Feed", dependencies: ["Helpers"], path: "Sources/Screens"),
        .target(name: "Routing", dependencies: ["Feed"])
    ]
)
