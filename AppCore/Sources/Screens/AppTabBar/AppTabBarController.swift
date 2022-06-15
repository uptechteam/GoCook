//
//  AppTabBarView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import Helpers
import Library
import UIKit

public protocol AppTabBarCoordinating: AnyObject {

}

public final class AppTabBarController: UITabBarController {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = AppTabBarView()
    private unowned let coordinator: AppTabBarCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: AppTabBarCoordinating
    ) {
        self.store = store
        self.actionCreator = actionCreator
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

    // MARK: - Private methods

    private func setupUI() {
        view.addSubview(contentView, constraints: [
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -21),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        tabBar.isHidden = true
    }

    private func setupBinding() {

    }
}
