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
    func login() async throws
    func logout() async throws
}

public final class ProfileFacade: ProfileFacading {

    // MARK: - Properties

    private let profileClient: ProfileClienting
    private let profileSubject: CurrentValueSubject<Profile?, Never>

    public var profile: AnyPublisher<Profile?, Never> {
        profileSubject.eraseToAnyPublisher()
    }

    // MARK: - Lifecycle

    public init(profileClient: ProfileClienting) {
        self.profileClient = profileClient
        self.profileSubject = CurrentValueSubject(nil)
    }

    // MARK: - Public methods

    public func getProfile() -> Profile {
        profileSubject.value!
    }

    public func login() async throws {
        let token = try await profileClient.login()
        print(token)
    }

    public func logout() async throws {
        try await profileClient.logout()
    }
}
