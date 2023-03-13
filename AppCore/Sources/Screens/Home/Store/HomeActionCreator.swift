//
//  HomeActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Combine
import Foundation

extension HomeViewController {
    public final class ActionCreator {

        // MARK: - Properties

        private let dependencies: Dependencies
        private var cancellables = [AnyCancellable]()

        // MARK: - Lifecycle

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }

        // MARK: - Public methods

        func observeFeed(handler: @escaping (Action) -> Void) {
            Task { [self] in
                await self.dependencies.homeFeedFacade.observeFeed()
                    .map(Action.updateFeed)
                    .sink(receiveValue: handler)
                    .store(in: &self.cancellables)
            }
        }

        func observeRecipes(handler: @escaping (Action) -> Void) {
            Task { [self] in
                await self.dependencies.searchRecipesFacade.observeFeed()
                    .map(Action.updateRecipes)
                    .sink(receiveValue: handler)
                    .store(in: &self.cancellables)
            }
        }
    }
}
