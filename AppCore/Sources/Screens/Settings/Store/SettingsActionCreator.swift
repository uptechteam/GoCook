//
//  SettingsActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Foundation
import Combine

extension SettingsViewController {

    public final class ActionCreator {

        private let dependencies: Dependencies
        private let cancellables = [AnyCancellable]()

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
