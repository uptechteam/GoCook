//
//  AppSettings.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2023.
//

import Foundation

public struct AppSettings: Equatable {

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

    public static let current: AppSettings = {
        switch AppEnvironment.current {
        case .development:
            return .init(
                baseURL: URL(string: "http://127.0.0.1:8080")!,
                isErrorReportingEnabled: isDebug,
                name: "development"
            )

        case .production:
            return .init(
                baseURL: URL(string: "https://go-go-cook.herokuapp.com")!,
                isErrorReportingEnabled: isDebug,
                name: "production"
            )
        }
    }()
}
