//
//  File.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import Foundation

public struct AppEnvironment: Equatable {

    public let baseURL: URL
    public let name: String

    public static let current: AppEnvironment = {
        #if DEBUG
        return developemnt
        #else
        return production
        #endif
    }()

    private static let developemnt = AppEnvironment(
        baseURL: URL(string: "http://127.0.0.1:8080")!,
        name: "development"
    )
    private static let production = AppEnvironment(
        baseURL: URL(string: "")!,
        name: "production"
    )
}
