//
//  TabBarPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import Combine

@MainActor
public final class TabBarPresenter {

    // MARK: - Properties

    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init() {
        self.state = State.makeInitialState()
    }

    // MARK: - Public methods

    func itemTapped(index: Int) {
        state.activeIndex = index
    }

    func selectInitialItem() {
        state.activeIndex = 1
    }
}
