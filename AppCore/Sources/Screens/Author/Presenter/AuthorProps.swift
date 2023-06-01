//
//  AuthorProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import Helpers

extension AuthorPresenter {
    static func makeProps(from state: State) -> AuthorView.Props {
        return .init(
            headerViewProps: makeHeaderViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> AuthorHeaderView.Props {
        return .init(
            avatarImageSource: state.author.avatar,
            name: state.author.username
        )
    }
}
