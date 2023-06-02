//
//  RecipesAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import DomainModels
import Foundation
import Helpers

struct RecipesAPI {

    // MARK: - Properties

    private let requestBuilder: RequestBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.requestBuilder = RequestBuilder(baseURL: baseURL.appendingPathComponent("recipes"))
    }

    // MARK: - Public methods

    func makeDeleteRemoveFromFavoritesRequest(recipeID: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makeDeleteRequest(path: "\(recipeID.rawValue)/favorite", authorisation: .bearer)
    }

    func makeGetFavoriteRecipesRequest(query: String, filters: RecipeFilters) throws -> AppRequest {
        let parameters = GetFavoriteRecipesParams(
            categoryFilters: filters.categories.map(makeCategoryFilter),
            query: query,
            timeFilters: filters.timeFilters.map(makeTimeFilter)
        )
        return try requestBuilder.makeGetRequest(path: "favorites", parameters: parameters, authorisation: .bearer)
    }

    func makeGetFeedRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "feed", authorisation: .bearer)
    }

    func makeGetRecipeRequest(id: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "\(id.rawValue)", authorisation: .bearer)
    }

    func makeGetRecipesRequest(authorID: User.ID, page: Int) throws -> AppRequest {
        let parameters: [String: String] = [
            "authorID": authorID.rawValue,
            "page": "\(page)",
            "pageSize": "\(AppConstants.Pagination.pageSize)"
        ]
        return try requestBuilder.makeGetRequest(path: "", parameters: parameters, authorisation: .bearer)
    }

    func makeGetRecipesRequest(query: String, filters: RecipeFilters, page: Int) throws -> AppRequest {
        let parameters = GetRecipesParams(
            categoryFilters: filters.categories.map(makeCategoryFilter),
            page: page,
            pageSize: AppConstants.Pagination.pageSize,
            query: query,
            timeFilters: filters.timeFilters.map(makeTimeFilter)
        )
        return try requestBuilder.makeGetRequest(path: "", parameters: parameters, authorisation: .bearer)
    }

    func makePostAddToFavoritesRequest(recipeID: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makePostRequest(path: "\(recipeID.rawValue)/favorite", authorisation: .bearer)
    }

    func makePostRateRequest(recipeID: Recipe.ID, rating: Int) throws -> AppRequest {
        let requestData = RatingRequest(rating: rating)
        return try requestBuilder.makePostJSONRequest(
            path: "\(recipeID.rawValue)/rating",
            requestData: requestData,
            authorisation: .bearer
        )
    }

    func makePostRecipeRequest(recipe: NewRecipe) throws -> AppRequest {
        let requestData = NewRecipeRequest(newRecipe: recipe)
        return try requestBuilder.makePostJSONRequest(path: "", requestData: requestData, authorisation: .bearer)
    }

    func makePutRecipeRequest(recipe: RecipeUpdate) throws -> AppRequest {
        let requestData = UpdateRecipeRequest(recipe: recipe)
        return try requestBuilder.makePostJSONRequest(
            path: "\(recipe.id.rawValue)",
            requestData: requestData,
            authorisation: .bearer
        )
    }

    // MARK: - Private methods

    private func makeCategoryFilter(category: CategoryType) -> String {
        switch category {
        case .breakfast:
            return "BREAKFAST"

        case .desserts:
            return "DESSERTS"

        case .dinner:
            return "DINNER"

        case .drinks:
            return "DRINKS"

        case .lunch:
            return "LUNCH"

        case .trending:
            return "TRENDING"
        }
    }

    private func makeTimeFilter(timeFilter: RecipeTimeFilter) -> String {
        switch timeFilter {
        case .fifteenToThirty:
            return "FIFTEEN_TO_THIRTY"

        case .fiveToFifteen:
            return "FIVE_TO_FIFTEEN"

        case .moreThanFortyFive:
            return "MORE_THAN_FORTY_FIVE"

        case .thirtyToFortyFive:
            return "THIRTY_TO_FORTY_FIVE"
        }
    }
}
