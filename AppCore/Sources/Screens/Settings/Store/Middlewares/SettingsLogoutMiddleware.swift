//
//  SettingsLogoutMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Foundation

extension SettingsViewController {

    static func makeLogoutMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            let oldState = getState()
            await next(action)
            let state = getState()

            guard state.isLoggingOut && !oldState.isLoggingOut else {
                return
            }

            await dependencies.profileFacade.logout()
            await dispatch(.logoutSuccess)
        }
    }
}
