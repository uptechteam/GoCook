//
//  AppSecrets.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2023.
//

import Foundation

public struct AppSecrets: Equatable {

    public let sentryDSN: String

    public static let shared: AppSecrets = {
        let sentryDSN = Bundle.main.object(forInfoDictionaryKey: Constants.sentryDSN) as? String
        guard let sentryDSN else {
            log.error("Can't get all secrets", metadata: ["Sentry dsn": .string("\(sentryDSN as Any)")])
            fatalError("Can't get all secrets.")
        }

        return AppSecrets(sentryDSN: sentryDSN)
    }()
}

// MARK: - Constants

private enum Constants {
    static let sentryDSN = "XCODE_SENTRY_DSN"
}
