//
//  TabBarProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers

extension TabBarPresenter {
    static func makeProps(from state: State) -> TabBarView.Props {
        return .init(
            favoritesImageSource: makeFavoritesImageSource(state: state),
            homeImageSource: makeHomeImageSource(state: state),
            profileImageSource: makeProfileImageSource(state: state)
        )
    }

    private static func makeFavoritesImageSource(state: State) -> ImageSource {
        .asset(state.activeIndex == 0 ? .favoritesTabBarIconSelected : .favoritesTabBarIconDeselected)
    }

    private static func makeHomeImageSource(state: State) -> ImageSource {
        .asset(state.activeIndex == 1 ? .homeTabBarIconSelected : .homeTabBarIconDeselected)
    }

    private static func makeProfileImageSource(state: State) -> ImageSource {
        .asset(state.activeIndex == 2 ? .profileTabBarIconSelected : .profileTabBarIconDeselected)
    }
}
