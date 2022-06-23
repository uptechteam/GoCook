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

    func makeLoginTarget() throws -> AppRequest {
        try targetBuilder.makePostTarget(path: "login", parameters: [:])
    }

    func makeLogoutTarget() throws -> AppRequest {
        try targetBuilder.makeDeleteTarget(path: "logout")
    }

    func makeRefreshProfileTarget() throws -> AppRequest {
        try targetBuilder.makeGetTarget(path: "me", parameters: [:])
    }
}
