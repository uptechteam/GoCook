//
//  FiltersViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import Helpers
import Library
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
        navigationItem.title = .filtersTitle
    }

    private func setupBinding() {
        contentView.categorySectionView.onTapOption = { [presenter] index in
            presenter.categoryTapped(index: index)
        }

        contentView.cookingTimeSectionView.onTapOption = { [presenter] index in
            presenter.cookingTimeTapped(index: index)
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map { state in FiltersPresenter.makeIsRightBarButtonHidden(from: state) }
            .sink { [unowned self] isHidden in
                renderRightBarButton(isHidden: isHidden)
            }
            .store(in: &cancellables)

        state
            .map { state in FiltersPresenter.makeProps(from: state) }
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)
    }

    private func renderRightBarButton(isHidden: Bool) {
        guard !isHidden else {
            navigationItem.rightBarButtonItem = nil
            return
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: .filtersClearAll,
            style: .plain,
            target: self,
            action: #selector(handleClearButtonTap)
        )
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            Typography.buttonLarge.getParameters(color: .primaryMain),
            for: .normal
        )
    }

    @objc
    private func handleClearButtonTap() {
        presenter.clearTapped()
    }
}
