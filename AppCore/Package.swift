// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Routing", targets: ["Routing"])
    ],
    dependencies: [.package(url: "https://github.com/onevcat/Kingfisher", from: "7.2.0")],
    targets: [
        // MARK: - App Core
        .target(name: "AppCore", dependencies: []),
        .testTarget(name: "AppCoreTests", dependencies: ["AppCore"]),
        // MARK: - Domain models
        .target(name: "DomainModels", dependencies: ["Helpers"]),
        // MARK: - Heleprs
        .target(name: "Helpers", dependencies: [.product(name: "Kingfisher", package: "Kingfisher")]),
        // MARK: - Library
        .target(
            name: "Library",
            dependencies: [],
            resources: [
                .copy("Resources/RedHatDisplay-Bold.otf"),
                .copy("Resources/RedHatDisplay-Medium.otf"),
                .copy("Resources/RedHatDisplay-Regular.otf"),
                .copy("Resources/RedHatText-Medium.otf")
            ]
        ),
        // MARK: - Routing
        .target(name: "Routing", dependencies: ["AppTabBar", "Favorites", "Filters", "Home", "Profile", "Recipe"]),
        // MARK: - Screens
        .target(name: "AppTabBar", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/AppTabBar"),
        .target(name: "Favorites", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Favorites"),
        .target(name: "Filters", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Filters"),
        .target(name: "Home", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Home"),
        .target(name: "Profile", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Profile"),
        .target(name: "Recipe", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Recipe")
    ]
)
