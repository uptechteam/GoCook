//
//  FiltersDescriptionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.03.2023.
//

import UIKit

public final class FiltersDescriptionView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let isVisible: Bool
        public let description: String

        // MARK: - Lifecycle

        public init(isVisible: Bool, description: String) {
            self.isVisible = isVisible
            self.description = description
        }
    }

    // MARK: - Properties

    private let topLineView = UIView()
    private let descriptionLabel = UILabel()
    private let bottomLineView = UIView()

    // MARK: - Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupStackView()
        setupTopLineView()
        setupDescriptionLabel()
        setupBottomLineView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topLineView, descriptionLabel, bottomLineView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            topLineView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -2 * 16),
            bottomLineView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func setupTopLineView() {
        topLineView.backgroundColor = .appBlack
        NSLayoutConstraint.activate([
            topLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
    }

    private func setupBottomLineView() {
        bottomLineView.backgroundColor = .appBlack
        NSLayoutConstraint.activate([
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Public methods

    public func render(props: Props) {
        isHidden = !props.isVisible
        descriptionLabel.render(title: props.description, color: .appBlack, typography: .description)
    }
}
