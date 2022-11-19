//
//  HomeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Library
import UIKit

final class HomeView: UIView {

    struct Props: Equatable {
        let feedViewProps: HomeFeedView.Props
    }

    // MARK: - Properties

    private let topStackView = UIStackView()
    let searchTextField = SearchTextField()
    let filtersButton = IconButton()
    let feedView = HomeFeedView()
    // callbacks
    var onDidChangeSearchQuery: (String) -> Void = { _ in }
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
        setupSearchTextField()
        setupFiltersButton()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTopStackView() {
        [searchTextField, filtersButton].forEach(topStackView.addArrangedSubview)
        topStackView.alignment = .center
        topStackView.spacing = 16
    }

    private func setupSearchTextField() {
        searchTextField.placeholder = .homeSearchPlaceholder
        searchTextField.delegate = self
    }

    private func setupFiltersButton() {
        filtersButton.set(image: .filters)
        filtersButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapFilters() }), for: .touchUpInside)
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, feedView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0),
            isSafeAreaRequired: true
        )
        NSLayoutConstraint.activate([
            topStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            feedView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        feedView.render(props: props.feedViewProps)
    }
}

// MARK: - Delegate

extension HomeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text ?? ""
        let newText = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        guard newText.count <= 30 else {
            return false
        }

        onDidChangeSearchQuery(newText)
        return true
    }
}
