//
//  APIError.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Foundation

enum APIError: Error {
    case cannotConnectToServer
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotConnectToServer:
            return .apiErrorConnotConnectToServer
        }
    }
}
