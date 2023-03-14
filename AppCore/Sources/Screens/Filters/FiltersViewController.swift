//
//  FiltersViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import Helpers
import UIKit

public protocol FiltersCoordinating: AnyObject {

}

public final class FiltersViewController: UIViewController {

    // MARK: - Properties

    private let presenter: FiltersPresenter
    private let contentView = FiltersView()
    private unowned let coordinator: FiltersCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: FiltersPresenter, coordinator: FiltersCoordinating) {
        self.presenter = presenter
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        setupUI()
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

    private func setupUI() {
        navigationItem.title = "Filters"
    }

    private func setupBinding() {
        let state = presenter.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state.map(FiltersViewController.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)
    }
}
