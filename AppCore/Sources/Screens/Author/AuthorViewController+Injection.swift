//
//  AuthorViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import BusinessLogic

public extension AuthorViewController {
    static func resolve(coordinator: AuthorCoordinating, envelope: AuthorEnvelope) -> AuthorViewController {
        return AuthorViewController(
            presenter: AuthorPresenter(
                userRecipesFacade: AppContainer.resolve(arguments: envelope.author.id),
                envelope: envelope
            ),
            coordinator: coordinator
        )
    }
}
