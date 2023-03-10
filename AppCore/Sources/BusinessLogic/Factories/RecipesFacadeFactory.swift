//
//  RecipesFacadeFactory.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import DomainModels
import Foundation

public final class RecipesFacadeFactory {

    // MARK: - Properties

    private var facades: [User.ID: RecipesFacading]

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

    public func produceFacade(userID: User.ID, producer: () throws -> RecipesFacading) rethrows -> RecipesFacading {
        if let facade = facades[userID] {
            return facade
        } else {
            let facade = try producer()
            facades[userID] = facade
            return facade
        }
    }

    // MARK: - Private methods

    @objc
    private func clear() {
        self.facades = [:]
    }
}
