//
//  ManageRecipeViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Combine
import DomainModels
import Helpers
import Library
import UIKit

public protocol ManageRecipeCoordinating: AnyObject {
    func didTapClose()
    func didTapInput(details: InputDetails)
}

public final class ManageRecipeViewController: UIViewController {

    // MARK: - Properties

    private let presenter: ManageRecipePresenter
    private let contentView = ManageRecipeView()
    private let imagePicker = ImagePicker()
    private unowned let coordinator: ManageRecipeCoordinating
    private var cancellables = [AnyCancellable]()

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    // MARK: - Lifecycle

    init(presenter: ManageRecipePresenter, coordinator: ManageRecipeCoordinating) {
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

    // MARK: - Public methods

    public func updateInput(details: InputDetails) {
        switch details {
        case let .ingredientAmount(id, amount, unit):
            presenter.ingredientAmountChanged(id: id, amount: amount, unit: unit)

        case let .ingredientName(id, name):
            presenter.ingredientNameChanged(id: id, name: name)

        case .numberOfServings(let number):
            presenter.amountChanged(text: number)

        case .cookingTime(let amount):
            presenter.cookingTimeChanged(amount: amount)
        }
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationItem.title = .manageRecipeTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .close,
            primaryAction: UIAction(handler: { [presenter] _ in presenter.closeTapped() })
        )
    }

    // swiftlint:disable:next function_body_length
    private func setupBinding() {
        contentView.stepOneView.recipeImageView.onTapImage = { [presenter] in
            presenter.recipeImageTapped()
        }

        contentView.stepOneView.mealNameInputView.onChangeText = { [presenter] text in
            presenter.mealNameChanged(name: text)
        }

        contentView.stepOneView.onTapCategory = { [presenter] indexPath in
            presenter.categoryItemTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.servingsView.onTap = { [presenter] in
            presenter.amountTapped()
        }

        contentView.stepTwoView.ingredientsView.onTapIngredientName = { [presenter] indexPath in
            presenter.ingredientNameTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.ingredientsView.onTapIngredientAmount = { [presenter] indexPath in
            presenter.ingredientAmountTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.ingredientsView.onTapDeleteIngredient = { [presenter] indexPath in
            presenter.deleteIngredientTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.ingredientsView.onTapAddIngredient = { [presenter] in
            presenter.addIngredientTapped()
        }

        contentView.stepThreeView.timeView.onTap = { [presenter] in
            presenter.cookingTimeTapped()
        }

        contentView.stepThreeView.instructionsView.onChangeText = { [presenter] index, text in
            presenter.instructionChanged(index: index, text: text)
        }

        contentView.stepThreeView.instructionsView.onTapDelete = { [presenter] index in
            presenter.deleteInstructionTapped(index: index)
        }

        contentView.stepThreeView.instructionsView.onTapAddInstruction = { [presenter] in
            presenter.addInstructionTapped()
        }

        contentView.stepFourView.headerView.recipeImageView.onTapImage = { [presenter] in
            presenter.recipeImageTapped()
        }

        contentView.stepsView.onTapBack = { [presenter] in
            presenter.backTapped()
        }

        contentView.stepsView.onTapNext = { [presenter] in
            presenter.nextTapped()
        }

        contentView.stepsView.onTapFinish = toSyncClosure { [presenter] in
            await presenter.finishTapped()
        }

        presenter.keyboardHeightChange
            .sink { [contentView] height in
                contentView.updateBottomInset(keyboardHeight: height)
            }
            .store(in: &cancellables)

        let state = presenter.$state
            .removeDuplicates()

        state
            .map { state in ManageRecipePresenter.makeProps(from: state) }
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.alert)
            .removeDuplicates()
            .map(\.value)
            .sink { [unowned self] alert in show(alert: alert) }
            .store(in: &cancellables)

        state.compactMap(\.route)
            .removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func show(alert: ManageRecipePresenter.Alert) {
        switch alert {
        case .deleteProgress:
            showDeleteProgressAlert()

        case .imagePicker(let isDeleteButtonVisible):
            showImagePicker(isDeleteButtonVisible: isDeleteButtonVisible)
        }
    }

    private func navigate(by route: ManageRecipePresenter.Route) {
        switch route {
        case .close:
            coordinator.didTapClose()

        case .inputTapped(let details):
            coordinator.didTapInput(details: details)
        }
    }

    private func showImagePicker(source: ImagePickerSource) {
        Task {
            guard let image = await imagePicker.pickImage(source: source, on: self) else {
                return
            }

            await presenter.imagePicked(image: .asset(image))
        }
    }
}

// MARK: - Alerts

private extension ManageRecipeViewController {
    private func showDeleteProgressAlert() {
        let alertController = UIAlertController(
            title: .manageRecipeAlertDeleteProgressTitle,
            message: .manageRecipeAlertDeleteProgressMessage,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: .manageRecipeAlertDeleteProgressCancel, style: .cancel))
        alertController.addAction(
            UIAlertAction(
                title: .manageRecipeAlertDeleteProgressDelete,
                style: .destructive,
                handler: { [presenter] _ in presenter.closeConfirmed() }
            )
        )
        present(alertController, animated: true)
    }

    private func showImagePicker(isDeleteButtonVisible: Bool) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(
            UIAlertAction(
                title: .imagePickerCamera,
                style: .default,
                handler: { [weak self] _ in self?.showImagePicker(source: .camera) }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: .imagePickerLibrary,
                style: .default,
                handler: { [weak self] _ in self?.showImagePicker(source: .photoAlbum) }
            )
        )
        if isDeleteButtonVisible {
            alertController.addAction(
                UIAlertAction(
                    title: .imagePickerRemove,
                    style: .default,
                    handler: { [presenter] _ in presenter.deleteTapped() }
                )
            )
        }
        alertController.addAction(UIAlertAction(title: .imagePickerCancel, style: .cancel))
        present(alertController, animated: true)
    }
}
