//
//  EditProfileAvatarView.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Helpers
import Library
import UIKit

final class EditProfileAvatarView: UIControl {

    struct Props: Equatable {
        let isSpinnerVisible: Bool
        let avatar: ImageSource?
    }

    // MARK: - Properties

    private let avatarImageView = UIImageView()
    private let cameraImageView = UIImageView()
    private let spinnerView = SpinnerView(circleColor: .appBlack)
    // callbacks
    var onTap: () -> Void = { }

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
        setupAvatarImageView()
        setupCameraImageView()
        setupSpinnerView()
    }

    private func setupContentView() {
        backgroundColor = .gray100
        clipsToBounds = true
        layer.roundCornersContinuosly(radius: Constants.side / 2)
        addAction(UIAction(handler: { [weak self] _ in self?.onTap() }), for: .touchUpInside)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Constants.side),
            heightAnchor.constraint(equalToConstant: Constants.side)
        ])
    }

    private func setupAvatarImageView() {
        avatarImageView.contentMode = .scaleAspectFill
        addSubview(avatarImageView, withEdgeInsets: .zero)
    }

    private func setupCameraImageView() {
        cameraImageView.image = .camera
        addSubview(cameraImageView, constraints: [
            cameraImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupSpinnerView() {
        spinnerView.set(imageSource: .asset(.close))
        addSubview(spinnerView, constraints: [
            spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        spinnerView.toggle(isAnimating: props.isSpinnerVisible)
        if let avatar = props.avatar {
            avatarImageView.set(avatar)
            cameraImageView.isHidden = true
        } else {
            avatarImageView.image = nil
            cameraImageView.isHidden = false
        }
    }
}

// MARK: - Constants

extension EditProfileAvatarView {
    private enum Constants {
        static let side: CGFloat = 160
    }
}
