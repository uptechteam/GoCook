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

    private let textLabel = UILabel()
    private let starsStackView = UIStackView()

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
    }

    private func setupTextLabel() {
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
    }

    private func setupStarsStackView() {
        (1...5)
            .map { _ in UIImageView() }
            .forEach(starsStackView.addArrangedSubview)
        starsStackView.spacing = 20
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [textLabel, starsStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 32, left: 24, bottom: 32, right: 24))
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
            .compactMap { $0 as? UIImageView }
            .enumerated()
            .forEach { index, imageView in
                imageView.image = index < rating ? .bigFilledStar : .bigEmptyStar
            }
    }
}
