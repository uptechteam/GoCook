// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Routing", targets: ["Routing"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.6.0"),
        .package(url: "https://github.com/AliSoftware/Dip", from: "7.1.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.2.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.4.0")
    ],
    targets: [
        // MARK: - App Core
        .target(name: "AppCore", dependencies: []),
        .testTarget(name: "AppCoreTests", dependencies: ["AppCore"]),
        // MARK: - Business logic
        .target(
            name: "BusinessLogic",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                "DomainModels",
                "Helpers"
            ],
            resources: [
                .process("PersistentProfile")
            ]
        ),
        // MARK: - Domain models
        .target(name: "DomainModels", dependencies: ["Helpers"]),
        // MARK: - Heleprs
        .target(
            name: "Helpers",
            dependencies: [
                .product(name: "Dip", package: "Dip"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        // MARK: - Library
        .target(name: "Library", dependencies: ["Helpers"], resources: [.process("Resources")]),
        // MARK: - Routing
        .target(
            name: "Routing",
            dependencies: ["AppTabBar", "BusinessLogic", "CreateRecipe", "Favorites", "Filters", "Home", "Profile", "Recipe"]
        ),
        // MARK: - Screens
        .target(name: "AppTabBar", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/AppTabBar"),
        .target(
            name: "CreateRecipe",
            dependencies: ["BusinessLogic", "DomainModels", "Helpers", "Library"],
            path: "Sources/Screens/CreateRecipe"
        ),
        .target(name: "Favorites", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Favorites"),
        .target(name: "Filters", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Filters"),
        .target(
            name: "Home",
            dependencies: ["BusinessLogic", "DomainModels", "Helpers", "Library"],
            path: "Sources/Screens/Home"
        ),
        .target(
            name: "Profile",
            dependencies: ["BusinessLogic", "DomainModels", "Helpers", "Library"],
            path: "Sources/Screens/Profile"
        ),
        .target(name: "Recipe", dependencies: ["DomainModels", "Helpers", "Library"], path: "Sources/Screens/Recipe")
    ]
)
