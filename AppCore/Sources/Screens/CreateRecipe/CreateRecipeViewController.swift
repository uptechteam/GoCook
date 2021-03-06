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

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = CreateRecipeView()
    private let imagePicker = ImagePicker()
    private unowned let coordinator: CreateRecipeCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: CreateRecipeCoordinating
    ) {
        self.store = store
        self.actionCreator = actionCreator
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
            store.dispatch(action: .ingredientAmountChanged(id: id, amount: amount, unit: unit))

        case let .ingredientName(id, name):
            store.dispatch(action: .ingredientNameChanged(id: id, name: name))

        case .numberOfServings(let number):
            store.dispatch(action: .amountChanged(number))

        case .cookingTime(let amount):
            store.dispatch(action: .cookingTimeChanged(amount: amount))
        }
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationItem.title = .createRecipeTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .close,
            primaryAction: UIAction(handler: { [store] _ in store.dispatch(action: .closeTapped) })
        )
    }

    // swiftlint:disable:next function_body_length
    private func setupBinding() {
        actionCreator.keyboardHeightChange
            .sink { [contentView] height in
                contentView.updateBottomInset(keyboardHeight: height)
            }
            .store(in: &cancellables)

        contentView.stepOneView.recipeView.onDidTapImage = { [store] in
            store.dispatch(action: .recipeImageTapped)
        }

        contentView.stepOneView.mealNameInputView.onDidChangeText = { [store] text in
            store.dispatch(action: .mealNameChanged(text))
        }

        contentView.stepOneView.onDidTapCategory = { [store] indexPath in
            store.dispatch(action: .categoryItemTapped(indexPath))
        }

        contentView.stepTwoView.servingsView.onDidTap = { [store] in
            store.dispatch(action: .amountTapped)
        }

        contentView.stepTwoView.ingredientsView.onDidTapIngredientName = { [store] indexPath in
            store.dispatch(action: .ingredientNameTapped(indexPath))
        }

        contentView.stepTwoView.ingredientsView.onDidTapIngredientAmount = { [store] indexPath in
            store.dispatch(action: .ingredientAmountTapped(indexPath))
        }

        contentView.stepTwoView.ingredientsView.onDidTapDeleteIngredient = { [store] indexPath in
            store.dispatch(action: .deleteIngredientTapped(indexPath))
        }

        contentView.stepTwoView.ingredientsView.onDidTapAddIngredient = { [store] in
            store.dispatch(action: .addIngredientTapped)
        }

        contentView.stepThreeView.timeView.onDidTap = { [store] in
            store.dispatch(action: .cookingTimeTapped)
        }

        contentView.stepThreeView.instructionsView.onDidChangeText = { [store] index, text in
            store.dispatch(action: .instructionChanged(index: index, text: text))
        }

        contentView.stepThreeView.instructionsView.onDidTapDelete = { [store] index in
            store.dispatch(action: .deleteInstructionTapped(index))
        }

        contentView.stepThreeView.instructionsView.onDidTapAddInstruction = { [store] in
            store.dispatch(action: .addInstructionTapped)
        }

        contentView.stepsView.onDidTapBack = { [store] in
            store.dispatch(action: .backTapped)
        }

        contentView.stepsView.onDidTapNext = { [store] in
            store.dispatch(action: .nextTapped)
        }

        contentView.stepsView.onDidTapFinish = { [store] in
            store.dispatch(action: .finishTapped)
        }

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .map(CreateRecipeViewController.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.alert).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] alert in show(alert: alert) }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func show(alert: Alert) {
        switch alert {
        case .deleteProgress:
            showDeleteProgressAlert()

        case .imagePicker(let isDeleteButtonPresent):
            showImagePicker(isDeleteButtonPresent: isDeleteButtonPresent)
        }
    }

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
                handler: { [store] _ in store.dispatch(action: .closeConfirmed) }
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
                handler: { [weak self] _ in self?.showImagePicker(source: .photoLibrary) }
            )
        )
        if isDeleteButtonPresent {
            alertController.addAction(
                UIAlertAction(
                    title: .imagePickerRemove,
                    style: .default,
                    handler: { [store] _ in store.dispatch(action: .deleteTapped) }
                )
            )
        }
        alertController.addAction(UIAlertAction(title: .imagePickerCancel, style: .cancel))
        present(alertController, animated: true)
    }

    private func showImagePicker(source: UIImagePickerController.SourceType) {
        Task { [weak self] in
            guard
                let self = self,
                let image = await imagePicker.pickImage(source: source, on: self)
            else {
                return
            }

            store.dispatch(action: .imagePicked(.asset(image)))
        }
    }

    private func navigate(by route: Route) {
        switch route {
        case .close:
            coordinator.didTapClose()

        case .inputTapped(let details):
            coordinator.didTapInput(details: details)
        }
    }
}
