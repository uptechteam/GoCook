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

    func makePostRecipeTarget(request: NewRecipeRequest) throws -> AppRequest {
        try targetBuilder.makePostJSONTarget(path: "", requestData: request, authorisation: .bearer)
    }
}
