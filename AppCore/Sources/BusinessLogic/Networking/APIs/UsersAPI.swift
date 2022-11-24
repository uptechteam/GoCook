//
//  UsersAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Foundation

struct UsersAPI {

    // MARK: - Properties

    private let requestBuilder: RequestBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.requestBuilder = RequestBuilder(baseURL: baseURL.appendingPathComponent("users"))
    }

    // MARK: - Public methods

    func makeIsUniqueRequest(username: String) throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "unique/\(username)")
    }

    func makeLoginRequest(username: String, password: String) throws -> AppRequest {
        try requestBuilder.makePostRequest(
            path: "login",
            authorisation: .login(username: username, password: password)
        )
    }

    func makeLogoutRequest() throws -> AppRequest {
        try requestBuilder.makeDeleteRequest(path: "logout", authorisation: .bearer)
    }

    func makeRefreshProfileRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "me", authorisation: .bearer)
    }

    func makeSignUpRequest(request: CreateUserRequest) throws -> AppRequest {
        try requestBuilder.makePostJSONRequest(path: "", requestData: request)
    }
}
