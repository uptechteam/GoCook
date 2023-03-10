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

    public private(set) var error: Error?
    public private(set) var isLoading: Bool = false
    private var model: Model?

    /// Check wether model is not nil
    public var isPresent: Bool {
        return model != nil
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Model, T>) -> T {
        return (model ?? .empty)[keyPath: keyPath]
    }

    // MARK: - Lifecycle

    public init(model: Model? = nil) {
        self.error = nil
        self.isLoading = false
        self.model = model
    }

    private init(error: Error?, isLoading: Bool, model: Model?) {
        self.error = error
        self.isLoading = isLoading
        self.model = model
    }

    // MARK: - Public methods

    /// Returns presented model or empty if there is no model.
    ///
    /// - Returns: `Model` model.
    public func getModel() -> Model {
        model ?? .empty
    }

    /// Update state according to result.
    ///
    /// - Parameter result: Result with either model or error.
    public mutating func handle(result: Result<Model, Error>) {
        switch result {
        case .failure(let error):
            setError(error)

        case .success(let domainModel):
            update(with: domainModel)
        }
    }

    /// Map model into new type preserving loading and error.
    ///
    /// - Parameter transform: Method to transform `Model` into `NewModel`.
    /// - Returns: New `DomainModelState` with type `NewModel`.
    public func map<NewModel>(transform: (Model) -> NewModel) -> DomainModelState<NewModel> {
        return DomainModelState<NewModel>(
            error: error,
            isLoading: isLoading,
            model: self.model.map(transform)
        )
    }

    /// Update loading state. Reset error if loading is started.
    ///
    /// - Parameter on: new loading status.
    public mutating func toggleIsLoading(on: Bool) {
        self.isLoading = on
        if on {
            self.error = nil
        }
    }

    // MARK: - Private methods

    /// Set error and toggle `isLoading` off.
    /// - Parameter error: error.
    private mutating func setError(_ error: Error) {
        self.error = error
        self.isLoading = false
    }

    /// Update domain model with new value and toggle `isLoading` off.
    ///
    /// - Parameter model: New value.
    public mutating func update(with model: Model) {
        self.model = model
        self.isLoading = false
    }
}

// MARK: - Equatable

extension DomainModelState {
    public static func == <T: EmptyDomainModel & Equatable>(
        lhs: DomainModelState<T>,
        rhs: DomainModelState<T>
    ) -> Bool {
        return lhs.model == rhs.model
        && lhs.isLoading == rhs.isLoading
        && lhs.error?.localizedDescription == rhs.error?.localizedDescription
    }
}

// MARK: - RangeReplaceableCollection

extension DomainModelState where Model: RangeReplaceableCollection {
    public mutating func append(_ result: Result<Model, Error>) {
        switch result {
        case .failure(let error):
            setError(error)

        case .success(let newModel):
            self.isLoading = false
            self.model = items + newModel
        }
    }
}

// MARK: - Model == Bool

extension DomainModelState where Model == Bool {
    public var value: Bool {
        model ?? .empty
    }
}

// MARK: - Model == Collection

extension DomainModelState where Model: Collection {
    public var items: Model {
        return model ?? .empty
    }
}
