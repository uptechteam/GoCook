//
//  InputViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension InputViewController {
    public static func resolve(envelope: InputEnvelope, coordinator: InputCoordinating) -> InputViewController {
        let dependencies = InputViewController.Dependencies(keyboardManager: AppContainer.resolve())
        return InputViewController(
            store: InputViewController.makeStore(dependencies: dependencies, envelope: envelope),
            actionCreator: InputViewController.ActionCreator(dependencies: dependencies),
            coordinator: coordinator
        )
    }
}
