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
    var onChangeText: (Int, String) -> Void = { _, _ in }
    var onTapDelete: (Int) -> Void = { _ in }
    var onTapAddInstruction: () -> Void = { }

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
        setupTitleLabel()
        setupInstructionsStackView()
        setupAddIngredientButton()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, instructionsStackView, addInstructionButton])
        stackView.axis = .vertical
        stackView.setCustomSpacing(24, after: titleLabel)
        addSubview(stackView, withEdgeInsets: .zero)
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
        addInstructionButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapAddInstruction() }),
            for: .touchUpInside
        )
        addInstructionButton.setImage(.addIcon)
        addInstructionButton.setTitle(.manageRecipeStepThreeAddStep)
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
        view.onChangeText = { [weak self] text in
            self?.onChangeText(index, text)
        }
        view.onTapDeleteButton = { [weak self] in
            self?.onTapDelete(index)
        }
        return view
    }
}
