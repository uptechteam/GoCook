//
//  AuthorPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import BusinessLogic
import Combine
import Foundation

@MainActor
public final class AuthorPresenter {

    // MARK: - Properties

    private let userRecipesFacade: UserRecipesFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(userRecipesFacade: UserRecipesFacading, envelope: AuthorEnvelope) {
        self.userRecipesFacade = userRecipesFacade
        self.state = State.makeInitialState(envelope: envelope)
        Task {
            await observeRecipes()
        }
    }

    // MARK: - Public methods

    func backTapped() {
        state.route = .init(value: .didTapBack)
    }

    func isFavoriteTapped(indexPath: IndexPath) {

    }

    func recipeTapped(indexPath: IndexPath) {

    }

    func scrolledToEnd() {

    }

    func scrolledToRefresh() {

    }

    func viewDidLoad() async {
        do {
            state.recipes.toggleIsLoading(on: true)
            try await userRecipesFacade.getFirstPage()
            state.recipes.toggleIsLoading(on: false)
        } catch {
            state.recipes.handle(result: .failure(error))
        }
    }

    // MARK: - Private methods

    private func observeRecipes() async {
        for await recipes in await userRecipesFacade.observeFeed().values {
            state.recipes.update(with: recipes)
        }
    }
}
