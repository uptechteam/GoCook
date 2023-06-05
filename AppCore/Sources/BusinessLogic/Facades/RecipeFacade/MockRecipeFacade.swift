//
//  MockRecipeFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import Combine
import DomainModels
import Helpers

public final class MockRecipeFacade: RecipeFacading {

    // MARK: - Lifecycle

    public init() {

    }

    // MARK: - Public methods

    public func addToFavorites() async throws {
        log.error("Mock class is used")
    }

    public func observeRecipe() async -> AnyPublisher<RecipeDetails, Never> {
        log.error("Mock class is used")
        return Empty().eraseToAnyPublisher()
    }

    public func rate(rating: Int) async throws {
        log.error("Mock class is used")
    }

    public func refreshRecipe() async throws {
        log.error("Mock class is used")
    }

    public func removeFromFavorites() async throws {
        log.error("Mock class is used")
    }
}
