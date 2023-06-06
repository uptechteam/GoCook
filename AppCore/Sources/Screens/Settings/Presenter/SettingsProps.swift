//
//  SettingsProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

extension SettingsPresenter {
    static func makeProps(from state: State) -> SettingsView.Props {
        return .init(
            isLoading: state.isLoggingOut
        )
    }
}
