//
//  HomeActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Combine
import Foundation

public extension HomeViewController {

    actor ActionCreator {

        private let dependencies: Dependencies
        private let cancellables = [AnyCancellable]()

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
