//
//  StepFourHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Helpers
import Library
import UIKit

final class StepFourHeaderView: UIView {

    struct Props: Equatable {
        let recipeImageSource: ImageSource
        let name: String
        let timeViewProps: RecipeTimeView.Props
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeStackView = UIStackView()
    private let timeView = RecipeTimeView()

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
        setupRecipeImageView()
        setupNameLabel()
        setupTimeStackView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupRecipeImageView() {
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupNameLabel() {
        nameLabel.render(typography: .headerTwo)
        nameLabel.textColor = .textMain
        nameLabel.numberOfLines = 0
    }

    private func setupTimeStackView() {
        [timeView, UIView()].forEach(timeStackView.addArrangedSubview)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [recipeImageView, nameLabel, timeStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(32, after: recipeImageView)
        stackView.setCustomSpacing(20, after: nameLabel)
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0))
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            nameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            timeStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource)
        nameLabel.text = props.name
        timeView.render(props: props.timeViewProps)
    }
}
