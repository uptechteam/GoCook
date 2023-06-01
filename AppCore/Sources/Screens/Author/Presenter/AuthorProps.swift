//
//  AuthorProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import Library

extension AuthorPresenter {
    static func makeProps(from state: State) -> AuthorView.Props {
        return .init(
            headerViewProps: makeHeaderViewProps(state: state),
            isCollectionViewVisible: false,
            items: [],
            recipesStateViewProps: makeRecipesStateViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> AuthorHeaderView.Props {
        return .init(
            avatarImageSource: state.author.avatar,
            name: state.author.username
        )
    }

    private static func makeRecipesStateViewProps(state: State) -> ContentStateView.Props {
        .message(title: .authorRecipesEmptyText, buttonTitle: nil)
    }
}
