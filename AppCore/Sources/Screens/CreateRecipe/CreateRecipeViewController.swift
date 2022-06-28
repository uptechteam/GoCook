//
//  CreateRecipeViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Combine
import Library
import UIKit

public protocol CreateRecipeCoordinating: AnyObject {
    func didTapClose()
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

    // MARK: - Private methods

    private func setupUI() {
        navigationItem.title = "Create recipe"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .close,
            primaryAction: UIAction(handler: { [store] _ in store.dispatch(action: .closeTapped) })
        )
    }

    private func setupBinding() {
        contentView.stepOneView.onDidTapImage = { [store] in
            store.dispatch(action: .recipeImageTapped)
        }
        contentView.stepsView.onDidTapBack = { [store] in
            store.dispatch(action: .backTapped)
        }

        contentView.stepsView.onDidTapNext = { [store] in
            store.dispatch(action: .nextTapped)
        }

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .map { CreateRecipeViewController.makeProps(from: $0) }
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.alert).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] alert in
                show(alert: alert)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in
                navigate(by: route)
            }
            .store(in: &cancellables)
    }

    private func show(alert: Alert) {
        switch alert {
        case .imagePicker(let isDeleteButtonPresent):
            showImagePicker(isDeleteButtonPresent: isDeleteButtonPresent)
        }
    }

    private func showImagePicker(isDeleteButtonPresent: Bool) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(
            title: "Take photo",
            style: .default,
            handler: { [weak self] _ in self?.showImagePicker(source: .camera) }
        )
        alertController.addAction(cameraAction)
        let galleryAction = UIAlertAction(
            title: "Choose from library",
            style: .default,
            handler: { [weak self] _ in self?.showImagePicker(source: .photoLibrary) }
        )
        alertController.addAction(galleryAction)
        if isDeleteButtonPresent {
            let deleteAction = UIAlertAction(
                title: "Remove current photo",
                style: .default,
                handler: { [store] _ in store.dispatch(action: .deleteTapped) }
            )
            alertController.addAction(deleteAction)
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    private func showImagePicker(source: UIImagePickerController.SourceType) {
        Task { [weak self] in
            guard let self = self else {
                return
            }

            let image = await imagePicker.pickImage(source: source, on: self)
            store.dispatch(action: .imagePicked(.asset(image)))
        }
    }

    private func navigate(by route: Route) {
        switch route {
        case .close:
            coordinator.didTapClose()
        }
    }
}
