//
//  Filter.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

public struct Filter {

    // MARK: - Properties

    public let predicates: [Predicate]

    // MARK: - Lifecycle

    public init(predicates: [Predicate]) {
        self.predicates = predicates
    }

    // MARK: - Public methods

    public func makePredicateExpression() -> String {
        return predicates.map { $0.makeExpression() }.joined(separator: " AND ")
    }

    public func getArguments() -> [Any] {
        return predicates.map { $0.getArgument() }
    }
}
