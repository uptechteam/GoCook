//
//  LoginActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Foundation
import Combine

extension LoginViewController {

    public final class ActionCreator {

        private let dependencies: Dependencies
        private let cancellables = [AnyCancellable]()

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
