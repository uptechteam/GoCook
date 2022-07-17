//
//  RecipeCategoryHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.07.2022.
//

import Library
import UIKit

final class RecipeCategoryHeaderView: UICollectionReusableView {

    struct Props: Equatable {
        let title: String
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let viewAllButton = UIButton()
    // callbacks
    var onDidTapViewAll: () -> Void = { }

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
        setupTitleLabel()
        setupViewAllButton()
        setupStackView()
    }

    private func setupTitleLabel() {
        titleLabel.render(typography: .headerTwo)
    }

    private func setupViewAllButton() {
        viewAllButton.setTitle(.homeCategoryViewAll, for: .normal)
        viewAllButton.setTitleColor(.primaryMain, for: .normal)
        viewAllButton.setTitleColor(.primaryPressed, for: .highlighted)
        viewAllButton.titleLabel?.render(typography: .buttonLarge)
        viewAllButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapViewAll() }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), viewAllButton])
        stackView.alignment = .center
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.text = props.title
    }
}
