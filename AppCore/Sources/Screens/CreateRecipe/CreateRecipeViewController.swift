//
//  CreateRecipeViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Combine
import DomainModels
import Helpers
import Library
import UIKit

public protocol CreateRecipeCoordinating: AnyObject {
    func didTapClose()
    func didTapInput(details: InputDetails)
}

public final class CreateRecipeViewController: UIViewController {

    // MARK: - Properties

    private let presenter: CreateRecipePresenter
    private let contentView = CreateRecipeView()
    private let imagePicker = ImagePicker()
    private unowned let coordinator: CreateRecipeCoordinating
    private var cancellables = [AnyCancellable]()

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    // MARK: - Lifecycle

    init(presenter: CreateRecipePresenter, coordinator: CreateRecipeCoordinating) {
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
        navigationItem.title = .createRecipeTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .close,
            primaryAction: UIAction(handler: { [presenter] _ in presenter.closeTapped() })
        )
    }

    // swiftlint:disable:next function_body_length
    private func setupBinding() {
        contentView.stepOneView.recipeImageView.onDidTapImage = { [presenter] in
            presenter.recipeImageTapped()
        }

        contentView.stepOneView.mealNameInputView.onChangeText = { [presenter] text in
            presenter.mealNameChanged(name: text)
        }

        contentView.stepOneView.onDidTapCategory = { [presenter] indexPath in
            presenter.categoryItemTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.servingsView.onDidTap = { [presenter] in
            presenter.amountTapped()
        }

        contentView.stepTwoView.ingredientsView.onDidTapIngredientName = { [presenter] indexPath in
            presenter.ingredientNameTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.ingredientsView.onDidTapIngredientAmount = { [presenter] indexPath in
            presenter.ingredientAmountTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.ingredientsView.onDidTapDeleteIngredient = { [presenter] indexPath in
            presenter.deleteIngredientTapped(indexPath: indexPath)
        }

        contentView.stepTwoView.ingredientsView.onDidTapAddIngredient = { [presenter] in
            presenter.addIngredientTapped()
        }

        contentView.stepThreeView.timeView.onDidTap = { [presenter] in
            presenter.cookingTimeTapped()
        }

        contentView.stepThreeView.instructionsView.onDidChangeText = { [presenter] index, text in
            presenter.instructionChanged(index: index, text: text)
        }

        contentView.stepThreeView.instructionsView.onDidTapDelete = { [presenter] index in
            presenter.deleteInstructionTapped(index: index)
        }

        contentView.stepThreeView.instructionsView.onDidTapAddInstruction = { [presenter] in
            presenter.addInstructionTapped()
        }

        contentView.stepFourView.headerView.recipeImageView.onDidTapImage = { [presenter] in
            presenter.recipeImageTapped()
        }

        contentView.stepsView.onDidTapBack = { [presenter] in
            presenter.backTapped()
        }

        contentView.stepsView.onDidTapNext = { [presenter] in
            presenter.nextTapped()
        }

        contentView.stepsView.onDidTapFinish = toSyncClosure { [presenter] in
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
            .map { state in CreateRecipePresenter.makeProps(from: state) }
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

    private func show(alert: CreateRecipePresenter.Alert) {
        switch alert {
        case .deleteProgress:
            showDeleteProgressAlert()

        case .imagePicker(let isDeleteButtonPresent):
            showImagePicker(isDeleteButtonPresent: isDeleteButtonPresent)
        }
    }

    private func navigate(by route: CreateRecipePresenter.Route) {
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

private extension CreateRecipeViewController {
    private func showDeleteProgressAlert() {
        let alertController = UIAlertController(
            title: .createRecipeAlertDeleteProgressTitle,
            message: .createRecipeAlertDeleteProgressMessage,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: .createRecipeAlertDeleteProgressCancel, style: .cancel))
        alertController.addAction(
            UIAlertAction(
                title: .createRecipeAlertDeleteProgressDelete,
                style: .destructive,
                handler: { [presenter] _ in presenter.closeConfirmed() }
            )
        )
        present(alertController, animated: true)
    }

    private func showImagePicker(isDeleteButtonPresent: Bool) {
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
        if isDeleteButtonPresent {
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
