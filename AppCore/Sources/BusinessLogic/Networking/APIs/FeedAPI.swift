//
//  FeedAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import Foundation

struct FeedAPI {

    // MARK: - Properties

    private let targetBuilder: TargetBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.targetBuilder = TargetBuilder(baseURL: baseURL.appendingPathComponent("feed"))
    }

    // MARK: - Public methods

    func makeGetRecipesTarget() throws -> AppRequest {
        try targetBuilder.makeGetTarget(path: "", parameters: [:])
    }
}
