//
//  ProfileRecipesHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Library
import UIKit

final class ProfileRecipesHeaderView: UIView {

    struct Props: Equatable {
        let isAddNewButtonVisible: Bool
    }

    // MARK: - Properties

    private let myRecipesLabel = UILabel()
    private let addNewButton = Button(
        config: ButtonConfig(buttonSize: .medium, colorConfig: .primary, isBackgroundVisible: false)
    )
    // callbacks
    var onDidTapAddNew: () -> Void = { }

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
        setupMyRecipesLabel()
        setupAddNewButton()
        setupStackView()
    }

    private func setupMyRecipesLabel() {
        myRecipesLabel.render(title: .profileMyRecipes, color: .textMain, typography: .headerFour)
    }

    private func setupAddNewButton() {
        addNewButton.setTitle(.profileButtonAddMoreTitle)
        addNewButton.setImage(.addIcon)
        addNewButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapAddNew() }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [myRecipesLabel, UIView(), addNewButton])
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        addNewButton.isHidden = !props.isAddNewButtonVisible
    }
}
