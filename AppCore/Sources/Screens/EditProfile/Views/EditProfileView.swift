//
//  EditProfileView.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Library
import UIKit

final class EditProfileView: UIView {

    struct Props: Equatable {

    }

    // MARK: - Properties

    private let dividerView = UIView()

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
        setupDividerView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupDividerView() {
        dividerView.backgroundColor = .divider
        addSubview(dividerView, constraints: [
            dividerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {

    }
}
