//
//  SignUpViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension SignUpViewController {
    public static func resolve(envelope: SignUpEnvelope, coordinator: SignUpCoordinating) -> SignUpViewController {
        let dependencies = SignUpViewController.Dependencies(
            keyboardManager: AppContainer.resolve(),
            profileFacade: AppContainer.resolve()
        )
        return SignUpViewController(
            store: SignUpViewController.makeStore(dependencies: dependencies, envelope: envelope),
            actionCreator: SignUpViewController.ActionCreator(dependencies: dependencies),
            coordinator: coordinator
        )
    }
}
