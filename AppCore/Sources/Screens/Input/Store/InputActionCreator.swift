//
//  InputActionCreator.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import BusinessLogic
import Foundation
import Combine
import UIKit

extension InputViewController {

    public final class ActionCreator {

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
        }

        public init(dependencies: Dependencies) {
            self.dependencies = dependencies
        }
    }
}
