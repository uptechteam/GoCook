//
//  ProfileViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import Helpers
import UIKit

public protocol ProfileCoordinating: AnyObject {

}

public final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = ProfileView()
    private unowned let coordinator: ProfileCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: ProfileCoordinating
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

    public override func loadView() {
        view = contentView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    // MARK: - Private methods

    private func setupBinding() {
        let state = store.state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state.map(ProfileViewController.makeProps(from:))
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)
    }
}
