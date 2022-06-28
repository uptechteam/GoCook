//
//  InputProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

extension InputViewController {
    static func makeProps(from state: State) -> InputView.Props {
        .init(title: "Ingredient amount", placeholder: "Amount")
    }
}
