//
//  bottomAnchor.swift
//  
//
//  Created by Oleksii Andriushchenko on 19.11.2022.
//

import Library
import UIKit

final class HomeSearchResultsView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let isSpinnerVisible: Bool
        let isDescriptionLabelVisible: Bool
        let description: String
        let items: [String]
    }

    // MARK: - Properties

    private let spinnerView = SpinnerView(circleColor: .appBlack)
    private let descriptionLabel = UILabel()

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
        setupSpinnerView()
        setupDescriptionLabel()
    }

    private func setupSpinnerView() {
        addSubview(spinnerView, constraints: [
            spinnerView.topAnchor.constraint(equalTo: topAnchor, constant: 174),
            spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerView.widthAnchor.constraint(equalToConstant: 40),
            spinnerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupDescriptionLabel() {
        addSubview(descriptionLabel, constraints: [
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 174),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        spinnerView.toggle(isAnimating: props.isSpinnerVisible)
        descriptionLabel.isHidden = !props.isDescriptionLabelVisible
        descriptionLabel.render(title: props.description, color: .textDisabled, typography: .body)
    }
}
