//
//  LoginViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension LoginViewController {
    public static func resolve(envelope: LoginEnvelope, coordinator: LoginCoordinating) -> LoginViewController {
        let dependencies = LoginViewController.Dependencies(
            keyboardManager: AppContainer.resolve(),
            profileFacade: AppContainer.resolve()
        )
        return LoginViewController(
            store: LoginViewController.makeStore(dependencies: dependencies, envelope: envelope),
            actionCreator: LoginViewController.ActionCreator(dependencies: dependencies),
            coordinator: coordinator
        )
    }
}
