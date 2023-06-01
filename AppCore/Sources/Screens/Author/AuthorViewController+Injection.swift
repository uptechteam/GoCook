//
//  AuthorViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

public extension AuthorViewController {
    static func resolve(coordinator: AuthorCoordinating, envelope: AuthorEnvelope) -> AuthorViewController {
        return AuthorViewController(
            presenter: AuthorPresenter(envelope: envelope),
            coordinator: coordinator
        )
    }
}
