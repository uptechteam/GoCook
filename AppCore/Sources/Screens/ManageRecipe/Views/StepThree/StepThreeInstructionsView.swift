//
//  StepThreeInstructionsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Library
import UIKit

final class StepThreeInstructionsView: UIView {

    struct Props: Equatable {
        let instructionsProps: [StepThreeInstructionView.Props]
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let instructionsStackView = UIStackView()
    private let addInstructionButton = Button(
        config: ButtonConfig(buttonSize: .medium, colorConfig: .primary, isBackgroundVisible: false)
    )
    // callbacks
    var onDidChangeText: (Int, String) -> Void = { _, _ in }
    var onDidTapDelete: (Int) -> Void = { _ in }
    var onDidTapAddInstruction: () -> Void = { }

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
        setupTitleLabel()
        setupInstructionsStackView()
        setupAddIngredientButton()
        setupStackView()
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.render(title: .manageRecipeStepThreeInstructionsTitle, color: .textMain, typography: .subtitle)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupInstructionsStackView() {
        instructionsStackView.axis = .vertical
        instructionsStackView.spacing = 24
    }

    private func setupAddIngredientButton() {
        addInstructionButton.setTitle(.manageRecipeStepThreeAddStep)
        addInstructionButton.setImage(.addIcon)
        addInstructionButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapAddInstruction() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, instructionsStackView, addInstructionButton])
        stackView.axis = .vertical
        stackView.setCustomSpacing(24, after: titleLabel)
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        if props.instructionsProps.count == instructionsStackView.arrangedSubviews.count {
            update(instructions: props.instructionsProps)
        } else {
            render(instructions: props.instructionsProps)
        }
    }

    // MARK: - Private methods

    private func update(instructions: [StepThreeInstructionView.Props]) {
        let instructionViews = instructionsStackView.arrangedSubviews
            .compactMap { $0 as? StepThreeInstructionView }
        zip(instructionViews, instructions)
            .forEach { $0.updateUI(props: $1) }
    }

    private func render(instructions: [StepThreeInstructionView.Props]) {
        instructionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        instructions.enumerated()
            .map(createInstructionView(index:props:))
            .forEach(instructionsStackView.addArrangedSubview)
    }

    private func createInstructionView(index: Int, props: StepThreeInstructionView.Props) -> StepThreeInstructionView {
        let view = StepThreeInstructionView()
        view.render(props: props)
        view.onDidChangeText = { [weak self] text in
            self?.onDidChangeText(index, text)
        }
        view.onDidTapDeleteButton = { [weak self] in
            self?.onDidTapDelete(index)
        }
        return view
    }
}
