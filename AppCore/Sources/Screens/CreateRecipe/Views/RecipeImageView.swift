//
//  RecipeImageView.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers
import Library
import UIKit

final class RecipeImageView: UIView {

    struct Props: Equatable {
        let recipeImageSource: ImageSource?
        let isThreeDostImageViewVisible: Bool
        let isLoaderVisible: Bool
        let errorViewProps: ErrorView.Props
    }

    // MARK: - Properties

    private let imageView = UIImageView()
    private let threeDotsImageView = UIImageView()
    private let spinnerView = SpinnerView()
    private let errorView = ErrorView()
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
        setupThreeDotsImageView()
        setupSpinnerView()
        setupErrorView()
    }

    private func setupContentView() {
        backgroundColor = .gray100
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    private func setupImageView() {
        imageView.clipsToBounds = true
        addSubview(imageView, withEdgeInsets: .zero)
    }

    private func setupThreeDotsImageView() {
        threeDotsImageView.image = .threeDots
        imageView.addSubview(threeDotsImageView, constraints: [
            threeDotsImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            threeDotsImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12)
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

    private func setupErrorView() {
        addSubview(errorView, constraints: [
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        renderRecipeImageView(props: props)
        threeDotsImageView.isHidden = !props.isThreeDostImageViewVisible
        spinnerView.toggle(isAnimating: props.isLoaderVisible)
        errorView.render(props: props.errorViewProps)
    }

    // MARK: - Private methods

    private func renderRecipeImageView(props: Props) {
        if let imageSource = props.recipeImageSource {
            imageView.set(imageSource)
        } else if !props.isLoaderVisible {
            imageView.set(.asset(.addPhoto))
        } else {
            imageView.set(.asset(nil))
        }
        imageView.contentMode = props.recipeImageSource == nil ? .center : .scaleAspectFill
    }

    @objc
    private func handleTap() {
        onDidTapImage()
    }
}
