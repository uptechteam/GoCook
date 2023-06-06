//
//  InputViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension InputViewController {
    public static func resolve(envelope: InputEnvelope, coordinator: InputCoordinating) -> InputViewController {
        return InputViewController(
            presenter: InputPresenter(keyboardManager: AppContainer.resolve(), envelope: envelope),
            coordinator: coordinator
        )
    }
}
