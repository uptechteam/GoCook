//
//  DomainModelAction.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import Foundation

public enum DomainModelAction<Model> {
    case failure(Error)
    case success(Model)
    case trigger

    public var error: Error? {
        switch self {
        case .failure(let error):
            return error

        default:
            return nil
        }
    }
}
