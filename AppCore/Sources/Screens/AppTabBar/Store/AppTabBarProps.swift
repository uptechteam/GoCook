//
//  ApPTabBarProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation

extension AppTabBarController {
    static func makeProps(from state: State) -> AppTabBarView.Props {
        return .init(
            favoritesImageSource: .asset(state.activeIndex == 0 ? .favoritesTabBarIconSelected : .favoritesTabBarIconDeselected),
            homeImageSource: .asset(state.activeIndex == 1 ? .homeTabBarIconSelected : .homeTabBarIconDeselected),
            profileImageSource: .asset(state.activeIndex == 2 ? .profileTabBarIconSelected : .profileTabBarIconDeselected)
        )
    }
}
