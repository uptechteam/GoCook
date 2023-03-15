//
//  RecipeFacadeFactory.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.03.2023.
//

import DomainModels
import Foundation

public final class RecipeFacadeFactory {

    // MARK: - Properties

    private var facades: [Recipe.ID: RecipeFacading]

    // MARK: - Lifecycle

    public init() {
        self.facades = [:]

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clear),
            name: AppNotificationType.logout.notificationName,
            object: nil
        )
    }

    // MARK: - Public methods

    public func produceFacade(
        recipeID: Recipe.ID,
        producer: () throws -> RecipeFacading
    ) rethrows -> RecipeFacading {
        if let facade = facades[recipeID] {
            return facade
        } else {
            let facade = try producer()
            facades[recipeID] = facade
            return facade
        }
    }

    // MARK: - Private methods

    @objc
    private func clear() {
        self.facades = [:]
    }
}
