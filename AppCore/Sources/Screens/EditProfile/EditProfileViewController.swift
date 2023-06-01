//
//  EditProfileViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Combine
import UIKit

public protocol EditProfileCoordinating: AnyObject {

}

public final class EditProfileViewController: UIViewController {

    // MARK: - Properties

    private let presenter: EditProfilePresenter
    private let contentView = EditProfileView()
    private unowned let coordinator: EditProfileCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    init(presenter: EditProfilePresenter, coordinator: EditProfileCoordinating) {
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

    override public func loadView() {
        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    // MARK: - Private methods

    private func setupBinding() {
        let state = presenter.$state
            .removeDuplicates()

        state
            .map { state in EditProfilePresenter.makeProps(from: state) }
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route)
            .removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: EditProfilePresenter.Route) {
        switch route {

        }
    }
}
