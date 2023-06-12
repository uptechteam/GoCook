//
//  InputPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import BusinessLogic
import Combine
import DomainModels
import UIKit

@MainActor
public final class InputPresenter {

    // MARK: - Properties

    public let keyboardManager: KeyboardManaging
    @Published
    private(set) var state: State

    var keyboardHeightChange: any Publisher<CGFloat, Never> {
        keyboardManager.keyboardHeightChange
    }

    // MARK: - Lifecycle

    public init(keyboardManager: KeyboardManaging, envelope: InputEnvelope) {
        self.keyboardManager = keyboardManager
        self.state = State.makeInitialState(envelope: envelope)
    }

    // MARK: - Public methods

    func saveTapped() {
        switch state.inputDetails {
        case let .ingredientAmount(id, _, unit):
            let details = InputDetails.ingredientAmount(id: id, amount: state.text, unit: state.unit ?? unit)
            state.route = .init(value: .didFinish(details))

        case let .ingredientName(id, _):
            state.route = .init(value: .didFinish(.ingredientName(id: id, name: state.text)))

        case .numberOfServings:
            state.route = .init(value: .didFinish(.numberOfServings(state.text)))

        case .cookingTime:
            state.route = .init(value: .didFinish(.cookingTime(state.text)))
        }
    }

    func textChanged(_ text: String) {
        state.text = text
    }

    func unitSelected(index: Int) {
        state.unit = IngredientUnit.priorityOrded[safe: index]
    }
}
