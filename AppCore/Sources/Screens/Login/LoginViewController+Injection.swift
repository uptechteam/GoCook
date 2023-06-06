//
//  LoginViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension LoginViewController {
    public static func resolve(envelope: LoginEnvelope, coordinator: LoginCoordinating) -> LoginViewController {
        return LoginViewController(
            presenter: LoginPresenter(
                keyboardManager: AppContainer.resolve(),
                profileFacade: AppContainer.resolve(),
                envelope: envelope
            ),
            coordinator: coordinator
        )
    }
}
