//
//  APIError.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Foundation

enum APIError: Error {
    case brokenData
    case cannotConnectToServer
    case server(message: String)
    case unknownError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .brokenData:
            return .apiErrorBrokenData

        case .cannotConnectToServer:
            return .apiErrorConnotConnectToServer

        case .server(let message):
            return message

        case .unknownError:
            return .apiErrorUnknownError
        }
    }
}
