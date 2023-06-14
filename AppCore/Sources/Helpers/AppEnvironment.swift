//
//  AppEnvironment.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import Foundation

public struct AppEnvironment: Equatable {

    public let baseURL: URL
    public let isErrorReportingEnabled: Bool
    public let name: String

    private static var isDebug: Bool {
#if DEBUG
        true
#else
        false
#endif
    }

    public static let current: AppEnvironment = {
        let appEnvironment = Bundle.main.object(forInfoDictionaryKey: Constants.appEnvironment) as? String
        switch appEnvironment {
        case "development":
            return developemnt

        case "production":
            return production

        default:
            log.error("Can't get envrionemnt", metadata: ["App environment": .string("\(appEnvironment as Any)")])
            fatalError("Can't get environment")
        }
    }()

    private static let developemnt = AppEnvironment(
        baseURL: URL(string: "http://127.0.0.1:8080")!,
        isErrorReportingEnabled: isDebug,
        name: "development"
    )
    private static let production = AppEnvironment(
        baseURL: URL(string: "https://go-go-cook.herokuapp.com")!,
        isErrorReportingEnabled: isDebug,
        name: "production"
    )
}

// MARK: - Constants

private enum Constants {
    static let appEnvironment = "APP_ENVIRONMENT"
}
