//
//  ValidationError.swift
//  
//
//  Created by Oleksii Andriushchenko on 04.07.2022.
//

import Foundation

public enum ValidationError: Error {
    case nameLength
    case notUniqueUsername
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .nameLength:
            return .validationNameLength

        case .notUniqueUsername:
            return .validationNotUniqueUsername
        }
    }
}
