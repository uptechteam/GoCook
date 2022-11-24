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
        try requestBuilder.makeDeleteRequest(path: "\(recipeID.rawValue)/like")
    }

    func makeGetFavoriteRecipesRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "favorite")
    }

    func makeGetRecipeRequest(id: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "\(id.rawValue)")
    }

    func makeGetRecipesRequest(query: String) throws -> AppRequest {
        let parameters = ["query": query]
        return try requestBuilder.makeGetRequest(path: "", parameters: parameters)
    }

    func makePostLikeRequest(recipeID: Recipe.ID) throws -> AppRequest {
        try requestBuilder.makePostRequest(path: "\(recipeID.rawValue)/like")
    }

    func makePostRecipeRequest(request: NewRecipeRequest) throws -> AppRequest {
        try requestBuilder.makePostJSONRequest(path: "", requestData: request, authorisation: .bearer)
    }
}
