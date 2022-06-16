//
//  RecipeAuthorView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Helpers
import Library
import UIKit

final class RecipeAuthorView: UIView {

    struct Props: Equatable {
        let avatarImageSource: ImageSource
        let username: String
    }

    // MARK: - Properties

    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()

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
        setupAvatarImageView()
        setupStackView()
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

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, usernameLabel, UIView()])
        stackView.alignment = .center
        stackView.spacing = 6
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        avatarImageView.set(props.avatarImageSource)
        renderUsername(props.username)
    }

    // MARK: - Private methods

    private func renderUsername(_ text: String) {
        var attributes = Typography.description.parameters
        attributes[.underlineStyle] = NSUnderlineStyle.thick
        attributes[.underlineColor] = UIColor.divider
        usernameLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
