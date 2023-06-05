//
//  RecipeFeedbackView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeFeedbackView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let text: String
        let rating: Int
    }

    // MARK: - Properties

    private let textContainerView = UIView()
    private let textLabel = UILabel()
    private let starsStackView = UIStackView()
    // callbacks
    var onTapStar: (Int) -> Void = { _ in }

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
        setupTextLabel()
        setupStarsStackView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 158)
        ])
    }

    private func setupTextLabel() {
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textContainerView.addSubview(textLabel, constraints: [
            textLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: textContainerView.centerYAnchor)
        ])
    }

    private func setupStarsStackView() {
        (0...4)
            .map { index in
                let button = UIButton()
                button.addAction(UIAction(handler: { [weak self] _ in self?.onTapStar(index) }), for: .touchUpInside)
                return button
            }
            .forEach(starsStackView.addArrangedSubview)
        starsStackView.spacing = 20
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [textContainerView, starsStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 0, left: 24, bottom: 32, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        textLabel.render(title: props.text, color: .textMain, typography: .subtitleTwo)
        renderStars(rating: props.rating)
    }

    // MARK: - Private methods

    private func renderStars(rating: Int) {
        starsStackView.arrangedSubviews
            .compactMap { $0 as? UIButton }
            .enumerated()
            .forEach { index, button in
                button.setImage(index < rating ? .star30 : .starGray30, for: .normal)
            }
    }
}
