//
//  CreateRecipeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Library
import UIKit

final class CreateRecipeView: UIView {

    struct Props: Equatable {
        let stepOneViewProps: CreateRecipeStepOneView.Props
        let stepTwoViewProps: CreateRecipeStepTwoView.Props
        let stepThreeViewProps: CreateRecipeStepThreeView.Props
        let stepFourViewProps: CreateRecipeStepFourView.Props
        let stepsViewProps: CreateRecipeStepsView.Props
    }

    // MARK: - Properties

    let dividerView = UIView()
    let stepOneView = CreateRecipeStepOneView()
    let stepTwoView = CreateRecipeStepTwoView()
    let stepThreeView = CreateRecipeStepThreeView()
    let stepFourView = CreateRecipeStepFourView()
    let stepsView = CreateRecipeStepsView()

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
        setupStepsView()
        setupStackView()
        setupDividerView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupStepsView() {
        addSubview(stepsView, constraints: [
            stepsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -56),
            stepsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [stepOneView, stepTwoView, stepThreeView, stepFourView])
        addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: stepsView.topAnchor)
        ])
    }

    private func setupDividerView() {
        dividerView.backgroundColor = .divider
        addSubview(dividerView, constraints: [
            dividerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        stepOneView.render(props: props.stepOneViewProps)
        stepTwoView.render(props: props.stepTwoViewProps)
        stepThreeView.render(props: props.stepThreeViewProps)
        stepFourView.render(props: props.stepFourViewProps)
        stepsView.render(props: props.stepsViewProps)
    }
}