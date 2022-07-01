//
//  SignUpActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Foundation
import Combine

extension SignUpViewController {

    public final class ActionCreator {

        private let dependencies: Dependencies
        private let cancellables = [AnyCancellable]()

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
