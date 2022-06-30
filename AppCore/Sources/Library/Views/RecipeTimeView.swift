//
//  RecipeTimeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public final class RecipeTimeView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let timeDescription: String

        // MARK: - Lifecycle

        public init(timeDescription: String) {
            self.timeDescription = timeDescription
        }
    }

    // MARK: - Properties

    private let timeImageView = UIImageView()
    private let timeLabel = UILabel()

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
        setupTimeImageView()
        setupTimelabel()
        setupStackView()
    }

    private func setupTimeImageView() {
        timeImageView.image = .time
    }

    private func setupTimelabel() {
        timeLabel.render(typography: .description)
        timeLabel.textColor = .textMain
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [timeImageView, timeLabel])
        stackView.spacing = 6
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    public func render(props: Props) {
        timeLabel.text = props.timeDescription
    }
}
