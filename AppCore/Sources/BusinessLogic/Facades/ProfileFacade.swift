//
//  ProfileFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Combine
import DomainModels
import Foundation
import Helpers

public protocol ProfileFacading {
    /// Publisher that emits `Profile` each time it is changed
    var profile: AnyPublisher<Profile?, Never> { get }

    func getProfile() -> Profile
    func isUnique(username: String) async throws -> Bool
    func login(username: String, password: String) async throws
    func logout() async
    func signUp(username: String, password: String) async throws
    func update(profile: ProfileUpdate) async throws
    func upload(avatarData: Data) async throws -> String
}

public final class ProfileFacade: ProfileFacading {

    // MARK: - Properties

    private let fileClient: FileClienting
    private let profileClient: ProfileClienting
    private let profileStorage: ProfileStoraging
    private let userCredentialsStorage: UserCredentialsStoraging
    private let profileSubject: CurrentValueSubject<Profile?, Never>

    public var profile: AnyPublisher<Profile?, Never> {
        profileSubject.eraseToAnyPublisher()
    }

    // MARK: - Lifecycle

    public init(
        fileClient: FileClienting,
        profileClient: ProfileClienting,
        profileStorage: ProfileStoraging,
        userCredentialsStorage: UserCredentialsStoraging
    ) {
        self.fileClient = fileClient
        self.profileClient = profileClient
        self.profileStorage = profileStorage
        self.userCredentialsStorage = userCredentialsStorage
        self.profileSubject = CurrentValueSubject(nil)
        Task {
            await loadProfile()
        }
    }

    // MARK: - Public methods

    public func getProfile() -> Profile {
        profileSubject.value!
    }

    public func isUnique(username: String) async throws -> Bool {
        try await profileClient.isUnique(username: username)
    }

    public func login(username: String, password: String) async throws {
        let token = try await profileClient.login(username: username, password: password)
        userCredentialsStorage.store(accessKey: token)
        let profile = try await profileClient.refreshProfile()
        await store(profile: profile)
    }

    public func logout() async {
        do {
            try await profileClient.logout()
        } catch {
            log.error("Logout error", metadata: ["Description": .string(error.localizedDescription)])
        }
        await profileStorage.clear()
        userCredentialsStorage.clear()
        profileSubject.send(nil)
    }

    public func signUp(username: String, password: String) async throws {
        let profile = try await profileClient.signUp(username: username, password: password)
        let token = try await profileClient.login(username: username, password: password)
        userCredentialsStorage.store(accessKey: token)
        await store(profile: profile)
    }

    public func update(profile: ProfileUpdate) async throws {
        let profile = try await profileClient.update(profile: profile)
        await store(profile: profile)
    }

    public func upload(avatarData: Data) async throws -> String {
        try await fileClient.uploadAvatar(data: avatarData)
    }

    // MARK: - Private methods

    private func store(profile: Profile) async {
        await profileStorage.store(profile: profile)
        profileSubject.send(profile)
    }

    private func loadProfile() async {
        guard let profile = await profileStorage.getProfile() else {
            return
        }

        profileSubject.send(profile)
    }
}
