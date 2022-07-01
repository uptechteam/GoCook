//
//  StepThreeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Library
import UIKit

final class StepThreeView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let timeViewProps: StepThreeTimeView.Props
        let instructionsViewProps: StepThreeInstructionsView.Props
    }

    // MARK: - Properties

    let timeView = StepThreeTimeView()
    let instructionsView = StepThreeInstructionsView()
    private let spaceView = UIView()

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
        setupSpaceView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupSpaceView() {
        spaceView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [timeView, instructionsView, spaceView])
        stackView.axis = .vertical
        stackView.setCustomSpacing(56, after: timeView)
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        timeView.render(props: props.timeViewProps)
        instructionsView.render(props: props.instructionsViewProps)
    }
}
