//
//  DomainModelState.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import Foundation

@dynamicMemberLookup
public struct DomainModelState<Model: EmptyDomainModel & Equatable>: Equatable {

    // MARK: - Properties

    private var model: Model?
    public private(set) var isLoading: Bool = false
    public private(set) var error: Error?

    /// Check wether model is not nil
    public var isPresent: Bool {
        return model != nil
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Model, T>) -> T {
        return (model ?? .empty)[keyPath: keyPath]
    }

    // MARK: - Lifecycle

    public init() {
        model = nil
    }

    // MARK: - Public methods

    /// Update state according to action
    /// - Parameter action: Action with 3 possible cases.
    public mutating func handle(action: DomainModelAction<Model>) {
        switch action {
        case .failure(let error):
            setError(error)

        case .success(let domainModel):
            update(with: domainModel)

        case .trigger:
            toggleIsLoading(on: true)
        }
    }

    /// Update state according to action. In case of success it only stops loading.
    /// - Parameter voidAction: Action with 3 possible cases.
    public mutating func handle(voidAction: DomainModelAction<Void>) {
        switch voidAction {
        case .failure(let error):
            setError(error)

        case .success:
            toggleIsLoading(on: false)

        case .trigger:
            toggleIsLoading(on: true)
        }
    }

    /// Set error and toggle `isLoading` off.
    /// - Parameter error: error.
    public mutating func setError(_ error: Error) {
        self.error = error
        self.isLoading = false
    }

    /// Update loading state. Reset error if loading is started
    /// - Parameter on: new loading status
    public mutating func toggleIsLoading(on: Bool) {
        isLoading = on
        if on {
            error = nil
        }
    }

    /// Update domain model with new value and toggle `isLoading` off.
    /// - Parameter model: New value.
    public mutating func update(with model: Model) {
        self.model = model
        self.isLoading = false
    }

    public static func == <T: EmptyDomainModel & Equatable>(lhs: DomainModelState<T>, rhs: DomainModelState<T>) -> Bool {
        return lhs.model == rhs.model
            && lhs.isLoading == rhs.isLoading
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
    }
}

extension DomainModelState where Model: Collection {
    public var items: Model {
        return model ?? .empty
    }
}

extension DomainModelState where Model == Bool {
    public var value: Bool {
        return model ?? .empty
    }
}
