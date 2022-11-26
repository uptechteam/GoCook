//
//  RecipeInstructionsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public final class RecipeInstructionsView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let isVisible: Bool
        public let instructionsProps: [RecipeInstructionView.Props]

        // MARK: - Lifecycle

        public init(isVisible: Bool, instructionsProps: [RecipeInstructionView.Props]) {
            self.isVisible = isVisible
            self.instructionsProps = instructionsProps
        }
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
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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

    public func render(props: Props) {
        isHidden = !props.isVisible
        renderInstructions(props: props.instructionsProps)
    }

    // MARK: - Private methods

    private func renderInstructions(props: [RecipeInstructionView.Props]) {
        instructionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        props.map(createInstructionView).forEach(instructionsStackView.addArrangedSubview)
    }

    private func createInstructionView(props: RecipeInstructionView.Props) -> UIView {
        let instructionView = RecipeInstructionView()
        instructionView.render(props: props)
        return instructionView
    }
}
