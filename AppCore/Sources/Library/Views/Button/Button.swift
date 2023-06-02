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
    private let spinnerView = SpinnerView()
    // callbacks
    public var onTap: () -> Void = { }

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = config.backgroundColor(for: isHighlighted ? .highlighted : .normal)
            layer.borderColor = config.borderColor(for: isHighlighted ? .highlighted : .normal).cgColor
            titleLabel.render(
                title: titleLabel.text ?? "",
                color: config.titleColor(for: isHighlighted ? .highlighted : .normal),
                typography: config.titleTypography
            )
            imageView.tintColor = config.titleColor(for: isHighlighted ? .highlighted : .normal)
        }
    }

    public override var isEnabled: Bool {
        didSet {
            backgroundColor = config.backgroundColor(for: isEnabled ? .normal : .disabled)
            layer.borderColor = config.borderColor(for: isEnabled ? .normal : .disabled).cgColor
            titleLabel.render(
                title: titleLabel.text ?? "",
                color: config.titleColor(for: isEnabled ? .normal : .disabled),
                typography: config.titleTypography
            )
            imageView.tintColor = config.titleColor(for: isEnabled ? .normal : .disabled)
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
        setupTitleLabel()
        setupSpinnerView()
        setupStackView()
    }

    private func setupContentView() {
        layer.roundCornersContinuosly(radius: config.buttonSize.height / 2)
        backgroundColor = config.backgroundColor(for: .normal)
        layer.borderColor = config.borderColor(for: .normal).cgColor
        layer.borderWidth = config.borderWidth
        addAction(UIAction(handler: { [weak self] _ in self?.onTap() }), for: .touchUpInside)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: config.buttonSize.height)
        ])
    }

    private func setupImageView() {
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.isHidden = true
        imageView.tintColor = config.titleColor(for: .normal)
    }

    private func setupTitleLabel() {
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    func setupSpinnerView() {
        NSLayoutConstraint.activate([
            spinnerView.widthAnchor.constraint(equalTo: spinnerView.heightAnchor),
            spinnerView.heightAnchor.constraint(equalToConstant: config.buttonSize.height - 16)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView()
        switch config.imagePosition {
        case .left:
            [imageView, titleLabel, spinnerView].forEach(stackView.addArrangedSubview)

        case .right:
            [titleLabel, imageView, spinnerView].forEach(stackView.addArrangedSubview)
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
        titleLabel.render(title: title, color: config.titleColor(for: .normal), typography: config.titleTypography)
    }

    public func setImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
    }

    public func toggleLoading(on: Bool) {
        spinnerView.toggle(isAnimating: on)
        titleLabel.isHidden = on
        if on {
            imageView.isHidden = true
        } else {
            imageView.isHidden = imageView.image == nil
        }
    }
}
