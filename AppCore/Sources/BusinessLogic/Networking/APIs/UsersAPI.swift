//
//  UsersAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import DomainModels
import Foundation

struct UsersAPI {

    // MARK: - Properties

    private let requestBuilder: RequestBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.requestBuilder = RequestBuilder(baseURL: baseURL.appendingPathComponent("users"))
    }

    // MARK: - Public methods

    func makeGetIsUniqueRequest(username: String) throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "unique/\(username)")
    }

    func makePostLoginRequest(username: String, password: String) throws -> AppRequest {
        try requestBuilder.makePostRequest(
            path: "login",
            authorisation: .login(username: username, password: password)
        )
    }

    func makeDeleteLogoutRequest() throws -> AppRequest {
        try requestBuilder.makeDeleteRequest(path: "logout", authorisation: .bearer)
    }

    func makeGetProfileRequest() throws -> AppRequest {
        try requestBuilder.makeGetRequest(path: "me", authorisation: .bearer)
    }

    func makePostSignUpRequest(username: String, password: String) throws -> AppRequest {
        let requestData = CreateUserRequest(username: username, password: password)
        return try requestBuilder.makePostJSONRequest(path: "", requestData: requestData)
    }

    func makePutProfileRequest(update: ProfileUpdate) throws -> AppRequest {
        let requestData = UpdateProfileRequest(update: update)
        return try requestBuilder.makePutJSONRequest(path: "", requestData: requestData)
    }
}
