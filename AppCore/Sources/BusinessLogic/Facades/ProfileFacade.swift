//
//  ProfileFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Combine
import DomainModels

public protocol ProfileFacading {
    /// Publisher that emits `Profile` each time it is changed
    var profile: AnyPublisher<Profile?, Never> { get }

    func getProfile() -> Profile
    func login(username: String, password: String) async throws
    func logout() async throws
}

public final class ProfileFacade: ProfileFacading {

    // MARK: - Properties

    private let profileClient: ProfileClienting
    private let profileStorage: ProfileStoraging
    private let userCredentialsStorage: UserCredentialsStoraging
    private let profileSubject: CurrentValueSubject<Profile?, Never>

    public var profile: AnyPublisher<Profile?, Never> {
        profileSubject.eraseToAnyPublisher()
    }

    // MARK: - Lifecycle

    public init(
        profileClient: ProfileClienting,
        profileStorage: ProfileStoraging,
        userCredentialsStorage: UserCredentialsStoraging
    ) {
        self.profileClient = profileClient
        self.profileStorage = profileStorage
        self.userCredentialsStorage = userCredentialsStorage
        self.profileSubject = CurrentValueSubject(nil)
        loadProfile()
    }

    // MARK: - Public methods

    public func getProfile() -> Profile {
        profileSubject.value!
    }

    public func login(username: String, password: String) async throws {
        let token = try await profileClient.login()
        userCredentialsStorage.store(accessKey: token)
        let profile = try await profileClient.refreshProfile()
        profileStorage.store(profile: profile)
    }

    public func logout() async throws {
        try await profileClient.logout()
        userCredentialsStorage.clear()
    }

    // MARK: - Private methods

    private func loadProfile() {
        guard let profile = profileStorage.getProfile() else {
            return
        }

        profileSubject.send(profile)
    }
}
