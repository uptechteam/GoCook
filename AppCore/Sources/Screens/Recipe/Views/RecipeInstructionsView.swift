//
//  RecipeInstructionsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeInstructionsView: UIView {

    struct Props: Equatable {
        let instructionsProps: [RecipeInstructionView.Props]
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let instructionsStackView = UIStackView()

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
        setupTitleLabel()
        setupInstructionsStackView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTitleLabel() {
        titleLabel.render(title: "Instructions", color: .textMain, typography: .subtitle)
    }

    private func setupInstructionsStackView() {
        instructionsStackView.axis = .vertical
        instructionsStackView.spacing = 32
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, instructionsStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 24
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 32, left: 24, bottom: 32, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        renderInstructions(props: props.instructionsProps)
    }

    // MARK: - Private methods

    private func renderInstructions(props: [RecipeInstructionView.Props]) {
        instructionsStackView.arrangedSubviews.forEach(instructionsStackView.removeArrangedSubview)
        props.map(createInstructionView).forEach(instructionsStackView.addArrangedSubview)
    }

    private func createInstructionView(props: RecipeInstructionView.Props) -> UIView {
        let instructionView = RecipeInstructionView()
        instructionView.render(props: props)
        return instructionView
    }
}
