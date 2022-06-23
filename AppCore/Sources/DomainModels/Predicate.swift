//
//  Predicate.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

public enum Predicate {

    // MARK: - Properties

    case comprassion(property: String, type: String, value: Any)

    // MARK: - Public methods

    func makeExpression() -> String {
        switch self {
        case let .comprassion(property, type, _):
            return "\(property) \(type) %@"
        }
    }

    func getArgument() -> Any {
        switch self {
        case .comprassion(_, _, let value):
            return value
        }
    }
}
