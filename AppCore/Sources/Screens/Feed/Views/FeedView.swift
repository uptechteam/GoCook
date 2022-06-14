//
//  FeedView.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Library
import UIKit

final class FeedView: UIView {

    struct Props: Equatable {

    }

    // MARK: - Properties

    private let topStackView = UIStackView()
    let inputTextField = InputTextField()
    let filtersButton = IconButton()
    // callbacks
    var onDidTapFilters: () -> Void = { }

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
        setupTopStackView()
        setupInputTextField()
        setupFiltersButton()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTopStackView() {
        [inputTextField, filtersButton].forEach(topStackView.addArrangedSubview)
        topStackView.alignment = .center
        topStackView.spacing = 16
    }

    private func setupInputTextField() {
        inputTextField.placeholder = "Search..."
    }

    private func setupFiltersButton() {
        filtersButton.set(image: .filters)
        filtersButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapFilters() }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, UIView()])
        stackView.axis = .vertical
        addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 16, left: 24, bottom: 41, right: 24),
            isSafeAreaRequired: true
        )
    }

    // MARK: - Public methods

    func render(props: Props) {

    }
}
