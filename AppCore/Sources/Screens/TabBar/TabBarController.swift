//
//  TabBarView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import Helpers
import Library
import UIKit

public protocol TabBarCoordinating: AnyObject {

}

public final class TabBarController: UITabBarController {

    // MARK: - Properties

    private let presenter: TabBarPresenter
    private let contentView = TabBarView()
    private unowned let coordinator: TabBarCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: TabBarPresenter, coordinator: TabBarCoordinating) {
        self.presenter = presenter
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deinit \(self)")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }

    // MARK: - Public methods

    public func select(tabIndex: Int) {
        presenter.itemTapped(index: tabIndex)
    }

    public func selectInitialIndex() {
        presenter.selectInitialItem()
    }

    public func makeTabBarSnapshot() -> UIView? {
        contentView.snapshotView(afterScreenUpdates: false)
    }

    public func toggleTabBarVisibility(on: Bool) {
        contentView.isHidden = !on
    }

    // MARK: - Private methods

    private func setupUI() {
        tabBar.isHidden = true
        additionalSafeAreaInsets.bottom = 56
        view.addSubview(contentView, constraints: [
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupBinding() {
        contentView.onTapItem = { [presenter] index in
            presenter.itemTapped(index: index)
        }

        let state = presenter.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .sink { [weak self] state in
                self?.selectedIndex = state.activeIndex
            }
            .store(in: &cancellables)

        state.map(TabBarPresenter.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)
    }
}
