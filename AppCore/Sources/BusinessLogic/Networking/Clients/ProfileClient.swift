//
//  ProfileClient.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import DomainModels
import Foundation

public protocol ProfileClienting {
    func login() async throws -> String
    func logout() async throws
    func refreshProfile() async throws -> Profile
}

public final class ProfileClient: ProfileClienting {

    // MARK: - Properties

    private let api: UsersAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.api = UsersAPI(baseURL: URL(string: "http://127.0.0.1:8080")!)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func login() async throws -> String {
        let appRequest = try api.makeLoginTarget()
        let response: String = try await networkClient.request(appRequest)
        return response
    }

    public func logout() async throws {
        let appRequest = try api.makeLogoutTarget()
        let _: String = try await networkClient.request(appRequest)
    }

    public func refreshProfile() async throws -> Profile {
        let appRequest = try api.makeRefreshProfileTarget()
        let response: UserResponse = try await networkClient.request(appRequest)
        return response.domainModel
    }
}
