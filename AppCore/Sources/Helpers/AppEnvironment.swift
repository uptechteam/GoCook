//
//  AppEnvironment.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import Foundation

public enum AppEnvironment: Equatable {

    case development
    case production

    // MARK: - Properties

    public static let current: AppEnvironment = {
        let appEnvironment = Bundle.main.object(forInfoDictionaryKey: Constants.appEnvironment) as? String
        switch appEnvironment {
        case "development":
            return .development

        case "production":
            return .production

        default:
            log.error(
                "Can't get envrionemnt, use production.",
                metadata: ["App environment": .string("\(appEnvironment as Any)")]
            )
            return .production
        }
    }()
}

// MARK: - Constants

private enum Constants {
    static let appEnvironment = "APP_ENVIRONMENT"
}
