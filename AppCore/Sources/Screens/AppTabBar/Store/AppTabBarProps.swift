//
//  ApPTabBarProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation

extension AppTabBarController {
    static func makeProps(from state: State) -> AppTabBarView.Props {
        .init(activeIndex: state.activeIndex)
    }
}
