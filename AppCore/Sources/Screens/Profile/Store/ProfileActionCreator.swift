//
//  Profile.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//
import Foundation
import Combine

extension ProfileViewController {

    public final class ActionCreator {

        private let dependencies: Dependencies
        private let cancellables = [AnyCancellable]()

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
