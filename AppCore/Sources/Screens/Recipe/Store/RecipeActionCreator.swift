//
//  RecipeActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation
import Combine

extension RecipeViewController {
    public final class ActionCreator {

        // MARK: - Properties

        private let dependencies: Dependencies
        private var cancellables = [AnyCancellable]()

        // MARK: - Lifecycle

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }

        // MARK: - Public methods

        func observeRecipeDetails(handler: @escaping (Action) -> Void) {
            Task {
                await dependencies.recipeFacade.observeRecipe()
                    .map(Action.updateRecipeDetails)
                    .sink(receiveValue: handler)
                    .store(in: &cancellables)
            }
        }
    }
}
