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

    private let titleLabel = ShimmeringLabel()
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
        setupStackView()
        setupViewAllButton()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), viewAllButton])
        stackView.alignment = .center
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
    }

    private func setupViewAllButton() {
        viewAllButton.titleLabel?.font = Typography.buttonLarge.font
        viewAllButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapViewAll() }), for: .touchUpInside)
        viewAllButton.setTitle(.homeCategoryViewAll, for: .normal)
        viewAllButton.setTitleColor(.primaryMain, for: .normal)
        viewAllButton.setTitleColor(.primaryPressed, for: .highlighted)
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.render(title: props.title, color: .appBlack, typography: .headerTwo)
    }
}
