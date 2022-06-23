//
//  CreateRecipeActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Foundation
import Combine

extension CreateRecipeViewController {

    public final class ActionCreator {

        private let dependencies: Dependencies
        private let cancellables = [AnyCancellable]()

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
