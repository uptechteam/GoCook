//
//  BusinessLogicError.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.03.2023.
//

import Foundation

public enum BusinessLogicError: Error {
    case logicIsBroken
}

// MARK: - LocalizedError

extension BusinessLogicError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .logicIsBroken:
            return "Can't proceed, something went wrong"
        }
    }
}
