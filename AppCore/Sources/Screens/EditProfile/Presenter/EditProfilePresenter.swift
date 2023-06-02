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
    private var uploadImageTask: Task<String, Error>?

    // MARK: - Lifecycle

    public init(profileFacade: ProfileFacading) {
        self.profileFacade = profileFacade
        self.state = State.makeInitialState(profile: profileFacade.getProfile())
    }

    // MARK: - Public methods

    func avatarTapped() {
        if state.avatar.isUploading {
            uploadImageTask?.cancel()
        } else {
            state.alert = .init(value: .avatarActionSheet(isDeleteVisible: state.avatar.image != nil))
        }
    }

    func closeTapped() {
        state.route = .init(value: .didTapClose)
    }

    func deleteTapped() {
        state.avatar = .empty
    }

    func imagePicked(image: ImageSource) async {
        state.avatar = .uploading(image)
        do {
            if let imageID = try await upload(imageSource: image) {
                state.avatar = .uploaded(image, imageID: imageID)
            } else {
                state.avatar = state.profile.avatar.flatMap(EditProfileAvatar.avatar) ?? .empty
            }
        } catch {
            state.avatar = state.profile.avatar.flatMap(EditProfileAvatar.avatar) ?? .empty
            state.alert = .init(value: .error(message: error.localizedDescription))
        }
    }

    func submitTapped() async {
        let update = ProfileUpdate(
            avatarURL: state.avatar.imageID,
            deleteAvatar: state.avatar == .empty,
            username: state.username
        )
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

    // MARK: - Private methods

    private func upload(imageSource: ImageSource) async throws -> String? {
        guard let data = imageSource.image?.pngData() else {
            print("Can't get data from picked image")
            return nil
        }

        uploadImageTask = Task {
            try await profileFacade.upload(avatarData: data)
        }
        let imageID = try await uploadImageTask?.value
        let isCancelled = uploadImageTask?.isCancelled ?? true
        return isCancelled ? nil : imageID
    }
}
