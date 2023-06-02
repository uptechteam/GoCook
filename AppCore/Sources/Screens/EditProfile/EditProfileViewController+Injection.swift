//
//  EditProfileViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import BusinessLogic

public extension EditProfileViewController {
    static func resolve(coordinator: EditProfileCoordinating) -> EditProfileViewController {
        return EditProfileViewController(
            presenter: EditProfilePresenter(profileFacade: AppContainer.resolve()),
            coordinator: coordinator
        )
    }
}
