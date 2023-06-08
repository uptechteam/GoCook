//
//  RecipeIngredientView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public final class RecipeIngredientView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let name: String
        public let weightDescription: String

        // MARK: - Lifecycle

        public init(name: String, weightDescription: String) {
            self.name = name
            self.weightDescription = weightDescription
        }
    }

    // MARK: - Properties

    private let pointView = UIView()
    private let nameLabel = UILabel()
    private let weightLabel = UILabel()

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
        setupPointView()
        setupNameLabel()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, UIView(), weightLabel])
        stackView.alignment = .top
        stackView.setCustomSpacing(10, after: nameLabel)
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0))
    }

    private func setupPointView() {
        pointView.backgroundColor = .textMain
        pointView.layer.roundCornersContinuosly(radius: 2)
        addSubview(pointView, constraints: [
            pointView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            pointView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pointView.widthAnchor.constraint(equalToConstant: 4),
            pointView.heightAnchor.constraint(equalTo: pointView.widthAnchor)
        ])
    }

    private func setupNameLabel() {
        nameLabel.numberOfLines = 0
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // MARK: - Public methods

    public func render(props: Props) {
        nameLabel.render(title: props.name, color: .textMain, typography: .body)
        weightLabel.render(title: props.weightDescription, color: .textMain, typography: .body)
    }
}
