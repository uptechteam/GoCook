//
//  RecipesAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

struct RecipesAPI {

    // MARK: - Properties

    private let targetBuilder: TargetBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.targetBuilder = TargetBuilder(baseURL: baseURL.appendingPathComponent("recipes"))
    }

    // MARK: - Public methods

    func makeGetRecipesTarget(query: String) throws -> AppRequest {
        let parameters = ["query": query]
        return try targetBuilder.makeGetTarget(path: "", parameters: parameters)
    }

    func makePostRecipeTarget(request: NewRecipeRequest) throws -> AppRequest {
        try targetBuilder.makePostJSONTarget(path: "", requestData: request, authorisation: .bearer)
    }
}
