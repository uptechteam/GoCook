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
        .package(url: "https://github.com/apple/swift-log", from: "1.4.0"),
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.7.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.7.0")

    ],
    targets: [
        // MARK: - Business logic
        .target(
            name: "BusinessLogic",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "Sentry", package: "sentry-cocoa"),
                "DomainModels",
                "Helpers"
            ],
            resources: [
                .process("Persistence/Resources")
            ]
        ),
        // MARK: - Domain models
        .target(name: "DomainModels", dependencies: ["Helpers"]),
        // MARK: - Helpers
        .target(
            name: "Helpers",
            dependencies: [
                .product(name: "Dip", package: "Dip"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        // MARK: - Library
        .target(name: "Library", dependencies: ["DomainModels", "Helpers"], resources: [.process("Resources")]),
        // MARK: - Routing
        .target(
            name: "Routing",
            dependencies: [
                "TabBar",
                "Author",
                "BusinessLogic",
                "ManageRecipe",
                "EditProfile",
                "Favorites",
                "Filters",
                "Home",
                "Input",
                "Login",
                "Profile",
                "Recipe",
                "Settings",
                "SignUp"
            ]
        ),
        // MARK: - Screens
        makeScreenModule(name: "TabBar"),
        makeScreenModule(name: "Author"),
        makeScreenModule(name: "ManageRecipe"),
        makeScreenModule(name: "EditProfile"),
        makeScreenModule(name: "Favorites"),
        makeScreenModule(name: "Filters"),
        makeScreenModule(name: "Home"),
        makeScreenModule(name: "Input"),
        makeScreenModule(name: "Login"),
        makeScreenModule(name: "Profile"),
        makeScreenModule(name: "Recipe"),
        makeScreenModule(name: "Settings"),
        makeScreenModule(name: "SignUp")
    ]
)

private func makeScreenModule(name: String) -> Target {
    return .target(
        name: name,
        dependencies: ["BusinessLogic", "DomainModels", "Helpers", "Library"],
        path: "Sources/Screens/\(name)"
    )
}
