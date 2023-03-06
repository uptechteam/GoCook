//
//  SignUpActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Combine
import UIKit

extension SignUpViewController {
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

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
