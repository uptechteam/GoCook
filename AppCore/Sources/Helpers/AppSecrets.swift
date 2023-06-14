//
//  AppSecrets.swift
//
//
//  Created by Oleksii Andriushchenko on 14.06.2023.
//

import Foundation

public struct AppSecrets: Equatable {

    public let sentryDSN: String

    public static let current: AppSecrets = {
        switch AppEnvironment.current {
        case .development:
            return .init(
                sentryDSN: "Add value"
            )

        case .production:
            return .init(
                sentryDSN: "Add value"
            )
        }
    }()
}
