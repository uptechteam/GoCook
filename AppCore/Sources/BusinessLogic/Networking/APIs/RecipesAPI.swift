//
//  RecipesAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import DomainModels
import Foundation

struct RecipesAPI {

    // MARK: - Properties

    private let requestBuilder: RequestBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.requestBuilder = RequestBuilder(baseURL: baseURL.appendingPathComponent("recipes"))
    }

    // MARK: - Public methods

    func makeDeleteDislikeRequest(recipeID: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makeDeleteRequest(path: "\(recipeID.rawValue)/like", authorisation: .bearer)
    }

    func makeGetFavoriteRecipesRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "favorite", authorisation: .bearer)
    }

    func makeGetFeedRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "feed", authorisation: .bearer)
    }

    func makeGetRecipeRequest(id: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "\(id.rawValue)", authorisation: .bearer)
    }

    func makeGetRecipesRequest(query: String) throws -> AppRequest {
        let parameters = ["query": query]
        return try requestBuilder.makeGetRequest(path: "", parameters: parameters)
    }

    func makePostLikeRequest(recipeID: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makePostRequest(path: "\(recipeID.rawValue)/like", authorisation: .bearer)
    }

    func makePostRateRequest(recipeID: Recipe.ID, rating: Int) throws -> AppRequest {
        return try requestBuilder.makePostJSONRequest(
            path: "\(recipeID.rawValue)/rating",
            requestData: ["rating": "\(rating)"],
            authorisation: .bearer
        )
    }

    func makePostRecipeRequest(request: NewRecipeRequest) throws -> AppRequest {
        try requestBuilder.makePostJSONRequest(path: "", requestData: request, authorisation: .bearer)
    }
}
