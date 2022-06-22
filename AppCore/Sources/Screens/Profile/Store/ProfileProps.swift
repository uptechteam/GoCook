//
//  ProfileProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation

extension ProfileViewController {
    static func makeProps(from state: State) -> ProfileView.Props {
        .init(
            headerViewProps: makeHeaderViewProps(state: state),
            recipesHeaderViewProps: makeRecipesHeaderViewProps(state: state),
            infoViewProps: makeInfoViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> ProfileHeaderView.Props {
        return .init(
            avatarImageSource: .asset(.avatarPlaceholder),
            isNameLabelVisible: false,
            isSignInButtonVisible: true
        )
    }

    private static func makeRecipesHeaderViewProps(state: State) -> ProfileRecipesHeaderView.Props {
        .init(isAddNewButtonVisible: false)
    }

    private static func makeInfoViewProps(state: State) -> ProfileInfoView.Props {
        return .init(
            isVisible: true,
            description: .profileNotSignedInTitle,
            isAddRecipeButtonVisible: false
        )
    }
}
