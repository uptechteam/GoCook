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
        let searchResultsViewProps: HomeSearchResultsView.Props
    }

    // MARK: - Properties

    private let topStackView = UIStackView()
    let searchTextField = SearchTextField()
    let filtersButton = IconButton()
    let feedView = HomeFeedView()
    let searchResultsView = HomeSearchResultsView()
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
        setupSearchResultsView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }

    private func setupTopStackView() {
        [searchTextField, filtersButton].forEach(topStackView.addArrangedSubview)
        topStackView.alignment = .center
        topStackView.spacing = 16
    }

    private func setupSearchTextField() {
        searchTextField.placeholder = .homeSearchPlaceholder
        searchTextField.tintColor = .appBlack
        searchTextField.delegate = self
    }

    private func setupFiltersButton() {
        filtersButton.set(image: .filters)
        filtersButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapFilters() }), for: .touchUpInside)
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupSearchResultsView() {
        searchResultsView.isHidden = true
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, feedView, searchResultsView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            topStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            feedView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            searchResultsView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        feedView.render(props: props.feedViewProps)
        searchResultsView.render(props: props.searchResultsViewProps)
    }

    // MARK: - Private methods

    @objc
    private func handleTap() {
        endEditing(true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension HomeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return false
        }

        return !(view is UIControl)
    }
}

// MARK: - UITextFieldDelegate

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
