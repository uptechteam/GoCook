//
//  RecipeAuthorView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Helpers
import Library
import UIKit

final class RecipeAuthorView: UIControl {

    struct Props: Equatable {
        let isVisible: Bool
        let avatarImageSource: ImageSource?
        let username: String
    }

    // MARK: - Properties

    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
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
        setupStackView()
        setupAvatarImageView()
    }

    private func setupContentView() {
        addAction(UIAction(handler: { [weak self] _ in self?.onTap() }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, usernameLabel, UIView()])
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.isUserInteractionEnabled = false
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupAvatarImageView() {
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.roundCornersContinuosly(radius: 9)
        avatarImageView.backgroundColor = .gray200
        avatarImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 18),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        if let avatar = props.avatarImageSource {
            avatarImageView.set(avatar)
        }

        renderUsername(props.username)
    }

    // MARK: - Private methods

    private func renderUsername(_ text: String) {
        var attributes = Typography.description.getAttributes(color: .appBlack)
        attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        attributes[.underlineColor] = UIColor.divider.cgColor
        usernameLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
