//
//  Button.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Helpers
import UIKit

public final class Button: UIControl {

    // MARK: - Properties

    private let config: ButtonConfig
    private let titleLabel = UILabel()
    private let imageView = UIImageView()

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = config.backgroundColor(for: isHighlighted ? .highlighted : .normal)
            layer.borderColor = config.borderColor(for: isHighlighted ? .highlighted : .normal).cgColor
            titleLabel.textColor = config.titleColor(for: isHighlighted ? .highlighted : .normal)
        }
    }

    public override var isEnabled: Bool {
        didSet {
            backgroundColor = config.backgroundColor(for: isEnabled ? .normal : .disabled)
            layer.borderColor = config.borderColor(for: isEnabled ? .normal : .disabled).cgColor
            titleLabel.textColor = config.titleColor(for: isEnabled ? .normal : .disabled)
        }
    }

    // MARK: - Lifecycle

    public required init(config: ButtonConfig = .init()) {
        self.config = config
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupImageView()
    }

    private func setupContentView() {
        layer.roundCornersContinuosly(radius: config.buttonSize.height / 2)
        backgroundColor = config.backgroundColor(for: .normal)
        layer.borderColor = config.borderColor(for: .normal).cgColor
        layer.borderWidth = config.borderWidth
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: config.buttonSize.height)
        ])
    }

    private func setupImageView() {
        imageView.isHidden = true
    }

    private func setupTitleLabel() {
        titleLabel.textColor = config.titleColor(for: .normal)
        switch config.buttonSize {
        case .large, .medium:
            titleLabel.render(typography: .buttonLarge)

        case .small:
            titleLabel.render(typography: .buttonSmall)
        }
    }

    private func setupStackView() {
        let stackView = UIStackView()
        switch config.imagePosition {
        case .left:
            [imageView, titleLabel].forEach(stackView.addArrangedSubview)

        case .right:
            [titleLabel, imageView].forEach(stackView.addArrangedSubview)
        }
        stackView.isUserInteractionEnabled = false
        stackView.spacing = 8
        stackView.alignment = .center
        let contentInsets = config.buttonSize.contentInsets
        addSubview(stackView, constraints: [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
                .prioritised(as: .defaultHigh),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
                .prioritised(as: .defaultHigh),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    public func setTitle(_ title: String) {
        titleLabel.text = title
    }

    public func setImageSource(_ imageSource: ImageSource) {
        imageView.set(imageSource)
    }
}
