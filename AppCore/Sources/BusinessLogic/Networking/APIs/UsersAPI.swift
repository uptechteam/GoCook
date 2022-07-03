//
//  UsersAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Foundation

struct UsersAPI {

    // MARK: - Properties

    private let targetBuilder: TargetBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.targetBuilder = TargetBuilder(baseURL: baseURL.appendingPathComponent("users"))
    }

    // MARK: - Public methods

    func makeLoginTarget(username: String, password: String) throws -> AppRequest {
        try targetBuilder.makePostTarget(
            path: "login",
            authorisation: .login(username: username, password: password)
        )
    }

    func makeLogoutTarget() throws -> AppRequest {
        try targetBuilder.makeDeleteTarget(path: "logout", authorisation: .bearer)
    }

    func makeRefreshProfileTarget() throws -> AppRequest {
        try targetBuilder.makeGetTarget(path: "me", authorisation: .bearer)
    }

    func makeSignUpTarget(request: CreateUserRequest) throws -> AppRequest {
        try targetBuilder.makePostJSONTarget(path: "", requestData: request)
    }
}
