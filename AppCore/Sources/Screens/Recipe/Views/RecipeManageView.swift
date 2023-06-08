//
//  RecipeManageView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Helpers
import Library
import UIKit

final class RecipeManageView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let isEditButtonVisible: Bool
        let isDeleteButtonVisible: Bool
    }

    // MARK: - Properties

    let shareButton = Button()
    let editButton = Button(config: ButtonConfig(isBackgroundVisible: false, isBorderVisible: true))
    let deleteButton = Button(
        config: ButtonConfig(colorConfig: .error, isBackgroundVisible: false, isBorderVisible: true)
    )
    // callbacks
    var onTapShare: () -> Void = { }
    var onTapEdit: () -> Void = { }
    var onTapDelete: () -> Void = { }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupStackView()
        setupShareButton()
        setupEditButton()
        setupDeleteButton()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [shareButton, editButton, deleteButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 32, left: 24, bottom: 44, right: 24))
    }

    private func setupShareButton() {
        shareButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapShare() }),
            for: .touchUpInside
        )
        shareButton.setImage(.share)
        shareButton.setTitle(.recipeShare)
    }

    private func setupEditButton() {
        editButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapEdit() }),
            for: .touchUpInside
        )
        editButton.setImage(.edit)
        editButton.setTitle(.recipeEdit)
    }

    private func setupDeleteButton() {
        deleteButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapDelete() }),
            for: .touchUpInside
        )
        deleteButton.setImage(.delete)
        deleteButton.setTitle(.recipeDelete)
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        editButton.isHidden = !props.isEditButtonVisible
        deleteButton.isHidden = !props.isDeleteButtonVisible
    }
}
