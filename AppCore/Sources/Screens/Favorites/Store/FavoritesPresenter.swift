//
//  FavoritesPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import BusinessLogic
import Combine
import DomainModels
import Helpers

@MainActor
public final class FavoritesPresenter {

    struct State: Equatable {
        var query: String
        var recipes: DomainModelState<[Recipe]>
        var route: AnyIdentifiable<Route>?
    }

    enum Route {
        case didTapFilters
    }

    public struct Dependencies {

        // MARK: - Properties

        let favoriteRecipesFacade: FavoriteRecipesFacading

        // MARK: - Lifecycle

        public init(favoriteRecipesFacade: FavoriteRecipesFacading) {
            self.favoriteRecipesFacade = favoriteRecipesFacade
        }
    }

    // MARK: - Properties

    // Dependencies
    private let dependencies: Dependencies
    // Variables
    @Published private(set) var state: State

    // MARK: - Lifecycle

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.state = State(query: "", recipes: DomainModelState(), route: nil)
        Task {
            await observeRecipes()
        }
    }

    // MARK: - Public methods

    func filtersTapped() {
        state.route = .init(value: .didTapFilters)
    }

    func searchQueryChanged(_ query: String) {
        state.query = query
    }

    func viewDidLoad() async {
        do {
            try await dependencies.favoriteRecipesFacade.getFavoriteRecipes()
            state.recipes.adjustState(accordingTo: .success(()))
        } catch {
            print("Error: \(error.localizedDescription)")
            state.recipes.adjustState(accordingTo: Result<Void, Error>.failure(error))
        }
    }

    // MARK: - Private methods

    private func observeRecipes() async {
        for await recipes in await dependencies.favoriteRecipesFacade.observeFeed().values {
            state.recipes.update(with: recipes)
        }
    }
}
