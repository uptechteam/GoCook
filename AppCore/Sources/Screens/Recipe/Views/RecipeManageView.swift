//
//  RecipeManageView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeManageView: UIView {

    struct Props: Equatable {
        let isEditButtonVisible: Bool
        let isDeleteButtonVisible: Bool
    }

    // MARK: - Properties

    let shareButton = UIButton()
    let editButton = UIButton()
    let deleteButton = UIButton()
    // callbacks
    var onDidTapShare: () -> Void = { }
    var onDidTapEdit: () -> Void = { }
    var onDidTapDelete: () -> Void = { }

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
        setupShareButton()
        setupEditButton()
        setupDeleteButton()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupShareButton() {
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.textMain, for: .normal)
        shareButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapShare() }),
            for: .touchUpInside
        )
    }

    private func setupEditButton() {
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.textMain, for: .normal)
        editButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapEdit() }),
            for: .touchUpInside
        )
    }

    private func setupDeleteButton() {
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.textMain, for: .normal)
        deleteButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapDelete() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [shareButton, editButton, deleteButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 32, left: 24, bottom: 44, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        editButton.isHidden = !props.isEditButtonVisible
        deleteButton.isHidden = !props.isDeleteButtonVisible
    }
}
