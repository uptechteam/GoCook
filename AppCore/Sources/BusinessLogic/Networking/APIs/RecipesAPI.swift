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

    func makeGetFavoriteRecipesRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "favorites", authorisation: .bearer)
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

    func makeGetRecipesRequest(query: String, page: Int) throws -> AppRequest {
        let parameters = [
            "page": "\(page)",
            "pageSize": "\(AppConstants.Pagination.pageSize)",
            "query": query
        ]
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

    func makePostRecipeRequest(request: NewRecipeRequest) throws -> AppRequest {
        try requestBuilder.makePostJSONRequest(path: "", requestData: request, authorisation: .bearer)
    }
}
