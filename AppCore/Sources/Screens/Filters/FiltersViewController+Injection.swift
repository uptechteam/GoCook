//
//  FiltersViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic
import DomainModels

extension FiltersViewController {
    public static func resolve(coordinator: FiltersCoordinating, envelope: FiltersEnvelope) -> FiltersViewController {
        return FiltersViewController(
            presenter: FiltersPresenter(
                filtersFacade: AppContainer.resolve(tag: createTag(envelope: envelope))
            ),
            coordinator: coordinator
        )
    }
}

private func createTag(envelope: FiltersEnvelope) -> FiltersFacadeTag {
    switch envelope {
    case .favorites:
        return .favorites

    case .home:
        return .home
    }
}
