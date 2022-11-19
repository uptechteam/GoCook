//
//  HomeRecipeCategoryHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.07.2022.
//

import Library
import UIKit

final class HomeRecipeCategoryHeaderView: UIView {

    struct Props: Equatable {
        let title: String
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let viewAllButton = UIButton()
    // callbacks
    var onTapViewAll: () -> Void = { }

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
        setupViewAllButton()
        setupStackView()
    }

    private func setupViewAllButton() {
        viewAllButton.setTitle(.homeCategoryViewAll, for: .normal)
        viewAllButton.setTitleColor(.primaryMain, for: .normal)
        viewAllButton.setTitleColor(.primaryPressed, for: .highlighted)
        viewAllButton.titleLabel?.render(typography: .buttonLarge)
        viewAllButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapViewAll() }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), viewAllButton])
        stackView.alignment = .center
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.render(title: props.title, color: .appBlack, typography: .headerTwo)
    }
}
