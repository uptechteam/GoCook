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
    var onTapAddNew: () -> Void = { }

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
        setupStackView()
        setupMyRecipesLabel()
        setupAddNewButton()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [myRecipesLabel, UIView(), addNewButton])
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupMyRecipesLabel() {
        myRecipesLabel.render(title: .profileMyRecipes, color: .textMain, typography: .headerFour)
    }

    private func setupAddNewButton() {
        addNewButton.setTitle(.profileButtonAddMoreTitle)
        addNewButton.setImage(.addIcon)
        addNewButton.addAction(UIAction(handler: { [unowned self] _ in onTapAddNew() }), for: .touchUpInside)
    }

    // MARK: - Public methods

    func render(props: Props) {
        addNewButton.isHidden = !props.isAddNewButtonVisible
    }
}
