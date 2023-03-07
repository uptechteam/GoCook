//
//  FeedAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import Foundation

struct FeedAPI {

    // MARK: - Properties

    private let requestBuilder: RequestBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.requestBuilder = RequestBuilder(baseURL: baseURL.appendingPathComponent("feed"))
    }

    // MARK: - Public methods

    func makeGetRecipesRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "", authorisation: .bearer)
    }
}
