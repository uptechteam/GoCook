//
//  LoginActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Combine
import UIKit

extension LoginViewController {
    public final class ActionCreator {

        // MARK: - Properties

        private let dependencies: Dependencies
        private let cancellables = [AnyCancellable]()

        var keyboardHeightChange: any Publisher<CGFloat, Never> {
            return dependencies.keyboardManager
                .change
                .map { change -> CGFloat in
                    switch change.notificationName {
                    case UIResponder.keyboardWillHideNotification:
                        return 0

                    default:
                        return change.frame.height
                    }
                }
                .removeDuplicates()
        }

        // MARK: - Lifecycle

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
