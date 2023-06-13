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
    public let sentryDSN: String

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
        name: "development",
        sentryDSN: getSentryDSN()
    )
    private static let production = AppEnvironment(
        baseURL: URL(string: "https://go-go-cook.herokuapp.com")!,
        isErrorReportingEnabled: isDebug,
        name: "production",
        sentryDSN: getSentryDSN()
    )

    // MARK: - Private methods

    private static func getSentryDSN() -> String {
        guard let dsn = ProcessInfo.processInfo.environment[Constants.sentryDSN] else {
            log.error("Can't obtain Sentry dsn. Add it to Xcode environment variables")
            fatalError("Can't obtain Sentry dsn. Add it to Xcode environment variables")
        }

        return dsn
    }
}

// MARK: - Constants

private enum Constants {
    static let appEnvironment = "APP_ENVIRONMENT"
    static let sentryDSN = "SENTRY_DSN"
}
