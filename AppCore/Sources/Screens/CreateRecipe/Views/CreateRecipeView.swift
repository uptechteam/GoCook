//
//  CreateRecipeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Helpers
import Library
import UIKit

final class CreateRecipeView: UIView {

    struct Props: Equatable {
        let stepOneViewProps: StepOneView.Props
        let stepTwoViewProps: StepTwoView.Props
        let stepThreeViewProps: StepThreeView.Props
        let stepFourViewProps: StepFourView.Props
        let stepsViewProps: CreateRecipeStepsView.Props
    }

    // MARK: - Properties

    private let dividerView = UIView()
    let stepOneView = StepOneView()
    let stepTwoView = StepTwoView()
    let stepThreeView = StepThreeView()
    let stepFourView = StepFourView()
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
        setupStepOneView()
        setupStepTwoView()
        setupStepThreeView()
        setupStepFourView()
        setupDividerView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }

    private func setupStepsView() {
        addSubview(stepsView, constraints: [
            stepsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -56),
            stepsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupStepOneView() {
        addSubview(stepOneView, constraints: [
            stepOneView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stepOneView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepOneView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepOneView.bottomAnchor.constraint(equalTo: stepsView.topAnchor)
        ])
    }

    private func setupStepTwoView() {
        addSubview(stepTwoView, constraints: [
            stepTwoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stepTwoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepTwoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepTwoView.bottomAnchor.constraint(equalTo: stepsView.topAnchor)
        ])
    }

    private func setupStepThreeView() {
        addSubview(stepThreeView, constraints: [
            stepThreeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stepThreeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepThreeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepThreeView.bottomAnchor.constraint(equalTo: stepsView.topAnchor)
        ])
    }

    private func setupStepFourView() {
        addSubview(stepFourView, constraints: [
            stepFourView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stepFourView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepFourView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepFourView.bottomAnchor.constraint(equalTo: stepsView.topAnchor)
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

    func updateBottomInset(keyboardHeight: CGFloat) {
        stepOneView.updateBottomInset(keyboardHeight: keyboardHeight)
        stepTwoView.updateBottomInset(keyboardHeight: keyboardHeight)
        stepThreeView.updateBottomInset(keyboardHeight: keyboardHeight)
    }

    // MARK: - Private methods

    @objc
    private func handleTap() {
        endEditing(true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CreateRecipeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return false
        }

        return !(view is UIControl)
    }
}
