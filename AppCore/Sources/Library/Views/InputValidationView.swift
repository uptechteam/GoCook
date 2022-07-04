//
//  InputValidationView.swift
//  
//
//  Created by Oleksii Andriushchenko on 04.07.2022.
//

import UIKit

public final class InputValidationView: UIView {

    public enum Props: Equatable {
        case empty
        case error
        case loading
        case valid
    }

    // MARK: - Properties

    private let iconImageView = UIImageView()
    private let spinnerView = SpinnerView(circleColor: .appBlack)

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
        setupIconImageView()
        setupSpinnerView()
    }

    private func setupContentView() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 20),
            heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupIconImageView() {
        addSubview(iconImageView, withEdgeInsets: .zero)
    }

    private func setupSpinnerView() {
        addSubview(spinnerView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = props == .empty
        spinnerView.toggle(isAnimating: props == .loading)
        iconImageView.image = getIcon(for: props)
    }

    // MARK: - Private methods

    private func getIcon(for props: Props) -> UIImage? {
        switch props {
        case .valid:
            return .checkGreen

        case .error:
            return .closeRed

        default:
            return nil
        }
    }
}
