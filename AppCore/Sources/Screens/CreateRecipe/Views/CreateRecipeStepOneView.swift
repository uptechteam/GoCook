//
//  CreateRecipeStepOneView.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Helpers
import Library
import UIKit

final class CreateRecipeStepOneView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let isLoaderVisible: Bool
        let recipeImageSource: ImageSource?
    }

    // MARK: - Properties

    private let imageView = UIImageView()
    private let spinnerView = SpinnerView()
    // callbacks
    var onDidTapImage: () -> Void = { }

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
        setupImageView()
        setupSpinnerView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupImageView() {
        imageView.backgroundColor = .gray100
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.image = .addPhoto
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageView.addGestureRecognizer(tapGesture)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

    private func setupSpinnerView() {
        imageView.addSubview(spinnerView, constraints: [
            spinnerView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            spinnerView.widthAnchor.constraint(equalToConstant: 48),
            spinnerView.heightAnchor.constraint(equalTo: spinnerView.widthAnchor)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [imageView, UIView()])
        stackView.axis = .vertical
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        if let imageSource = props.recipeImageSource {
            imageView.set(imageSource)
        } else if !props.isLoaderVisible {
            imageView.set(.asset(.addPhoto))
        } else {
            imageView.set(.asset(nil))
        }
        imageView.contentMode = props.recipeImageSource == nil ? .center : .scaleAspectFill
        spinnerView.toggle(isAnimating: props.isLoaderVisible)
    }

    // MARK: - Private methods

    @objc
    private func handleTap() {
        onDidTapImage()
    }
}
