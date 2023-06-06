//
//  RecipePresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import BusinessLogic
import DomainModels
import Foundation

@MainActor
public final class RecipePresenter {

    // MARK: - Properties

    let recipeFacade: RecipeFacading
    @Published
    var state: State

    // MARK: - Lifecycle

    public init(recipeFacade: RecipeFacading, envelope: RecipeEnvelope) {
        self.recipeFacade = recipeFacade
        self.state = State.makeInitialState(envelope: envelope)
        Task {
            await self.observeRecipeDetails()
        }
    }

    // MARK: - Public methods

    func authorTapped() {
        guard state.recipeDetails.isPresent else {
            return
        }

        state.route = .init(value: .didTapAuthor(state.recipeDetails.author))
    }

    func backTapped() {
        state.route = .init(value: .back)
    }

    func editTapped() {
        guard state.recipeDetails.isPresent else {
            return
        }

        state.route = .init(value: .didTapEdit(state.recipeDetails.getModel()))
    }

    func favoriteTapped() async {
        do {
            if state.recipeDetails.isFavorite {
                try await recipeFacade.removeFromFavorites()
            } else {
                try await recipeFacade.addToFavorites()
            }

            var details = state.recipeDetails.getModel()
            details.isFavorite.toggle()
            state.recipeDetails.handle(model: details)
        } catch {
            state.recipeDetails.handle(error: error)
        }
    }

    func retryTapped() async {
        state.recipeDetails.toggleIsLoading(on: true)
        await getRecipeDetails()
    }

    func starTapped(index: Int) async {
        var recipeDetails = state.recipeDetails.getModel()
        recipeDetails.rating = index + 1
        state.recipeDetails.handle(model: recipeDetails)
        do {
            let rating = index + 1
            try await recipeFacade.rate(rating: rating)
            state.recipeDetails.toggleIsLoading(on: false)
        } catch {
            state.recipeDetails.handle(error: error)
        }
    }

    func viewWillAppear() async {
        if !state.recipeDetails.isPresent {
            state.recipeDetails.toggleIsLoading(on: true)
        }

        await getRecipeDetails()
    }

    // MARK: - Private methods

    private func getRecipeDetails() async {
        do {
            try await recipeFacade.refreshRecipe()
            state.recipeDetails.toggleIsLoading(on: false)
        } catch {
            state.recipeDetails.handle(error: error)
        }
    }

    private func observeRecipeDetails() async {
        for await recipeDetails in await recipeFacade.observeRecipe().values {
            state.recipeDetails.handle(model: recipeDetails)
        }
    }
}
