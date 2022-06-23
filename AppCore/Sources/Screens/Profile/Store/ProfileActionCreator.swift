//
//  ProfileActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//
import Foundation
import Combine

extension ProfileViewController {

    public final class ActionCreator {

        // MARK: - Properties

        private let dependencies: Dependencies
        private var cancellables = [AnyCancellable]()

        // MARK: - Lifecycle

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }

        // MARK: - Public methods

        func subscribeToProfile(handler: @escaping (Action) -> Void) {
            dependencies.profileFacade.profile
                .map(Action.updateProfile)
                .sink(receiveValue: handler)
                .store(in: &cancellables)
        }
    }
}
