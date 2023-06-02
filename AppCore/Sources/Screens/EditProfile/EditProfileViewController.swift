//
//  EditProfileViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Combine
import DomainModels
import Helpers
import Library
import UIKit

public protocol EditProfileCoordinating: AnyObject {
    func didTapClose()
    func didUpdateProfile()
}

public final class EditProfileViewController: UIViewController, ErrorPresentable {

    // MARK: - Properties

    private let presenter: EditProfilePresenter
    private let contentView = EditProfileView()
    private let imagePicker = ImagePicker()
    private unowned let coordinator: EditProfileCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    init(presenter: EditProfilePresenter, coordinator: EditProfileCoordinating) {
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

    override public func loadView() {
        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .close,
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        navigationItem.title = .editProfileTitle
    }

    private func setupBinding() {
        contentView.avatarView.onTap = { [presenter] in
            presenter.avatarTapped()
        }

        contentView.usernameInputView.onChangeText = { [presenter] text in
            presenter.usernameChanged(text)
        }

        contentView.submitButton.onTap = toSyncClosure { [presenter] in
            await presenter.submitTapped()
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map { state in EditProfilePresenter.makeProps(from: state) }
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

    private func show(alert: EditProfilePresenter.Alert) {
        switch alert {
        case .avatarActionSheet(let isDeleteButtonVisible):
            showAvatarActionSheet(isDeleteButtonVisible: isDeleteButtonVisible)

        case .error(let message):
            show(errorMessage: message)
        }
    }

    private func navigate(by route: EditProfilePresenter.Route) {
        switch route {
        case .didTapClose:
            coordinator.didTapClose()

        case .didUpdateProfile:
            coordinator.didUpdateProfile()
        }
    }

    private func showImagePicker(source: ImagePickerSource) {
        Task {
            guard let image = await imagePicker.pickImage(source: source, on: self) else {
                return
            }

            presenter.imagePicked(image: .asset(image))
        }
    }

    @objc
    private func closeButtonTapped() {
        presenter.closeTapped()
    }
}

// MARK: - Alerts

extension EditProfileViewController {
    private func showAvatarActionSheet(isDeleteButtonVisible: Bool) {
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
