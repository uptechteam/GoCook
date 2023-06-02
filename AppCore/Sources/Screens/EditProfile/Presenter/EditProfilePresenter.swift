//
//  EditProfilePresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import BusinessLogic
import Combine
import DomainModels
import Helpers

@MainActor
public final class EditProfilePresenter {

    // MARK: - Properties

    private let profileFacade: ProfileFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(profileFacade: ProfileFacading) {
        self.profileFacade = profileFacade
        self.state = State.makeInitialState(profile: profileFacade.getProfile())
    }

    // MARK: - Public methods

    func avatarTapped() {
        state.alert = .init(value: .avatarActionSheet(isDeleteVisible: state.profile.avatar != nil))
    }

    func closeTapped() {
        state.route = .init(value: .didTapClose)
    }

    func deleteTapped() {
        state.avatar = nil
    }

    func imagePicked(image: ImageSource) {
        state.avatar = image
    }

    func submitTapped() async {
        let update = ProfileUpdate(avatarURL: nil, deleteAvatar: false, username: state.username)
        do {
            state.isUpdatingProfile = true
            try await profileFacade.update(profile: update)
            state.isUpdatingProfile = false
            state.route = .init(value: .didUpdateProfile)
        } catch {
            state.isUpdatingProfile = false
            state.alert = .init(value: .error(message: error.localizedDescription))
        }
    }

    func usernameChanged(_ text: String) {
        state.username = text
    }
}
