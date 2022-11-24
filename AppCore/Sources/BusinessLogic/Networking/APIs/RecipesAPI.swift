//
//  RecipesAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

struct RecipesAPI {

    // MARK: - Properties

    private let requestBuilder: RequestBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.requestBuilder = RequestBuilder(baseURL: baseURL.appendingPathComponent("recipes"))
    }

    // MARK: - Public methods

    func makeGetRecipesRequest(query: String) throws -> AppRequest {
        let parameters = ["query": query]
        return try requestBuilder.makeGetRequest(path: "", parameters: parameters)
    }

    func makePostRecipeRequest(request: NewRecipeRequest) throws -> AppRequest {
        try requestBuilder.makePostJSONRequest(path: "", requestData: request, authorisation: .bearer)
    }
}
