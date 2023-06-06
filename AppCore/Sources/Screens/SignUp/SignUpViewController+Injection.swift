//
//  SignUpViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension SignUpViewController {
    public static func resolve(envelope: SignUpEnvelope, coordinator: SignUpCoordinating) -> SignUpViewController {
        return SignUpViewController(
            presenter: SignUpPresenter(
                keyboardManager: AppContainer.resolve(),
                profileFacade: AppContainer.resolve(),
                envelope: envelope
            ),
            coordinator: coordinator
        )
    }
}
