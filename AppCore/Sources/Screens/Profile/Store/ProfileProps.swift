//
//  ProfileProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation

extension ProfileViewController {
    static func makeProps(from state: State) -> ProfileView.Props {
        .init(headerViewProps: makeHeaderViewProps(state: state))
    }

    private static func makeHeaderViewProps(state: State) -> ProfileHeaderView.Props {
        return .init(
            avatarImageSource: .asset(.avatarPlaceholder),
            isNameLabelVisible: false,
            isSignInButtonVisible: true
        )
    }
}
