//
//  LoginView.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Library
import UIKit

final class LoginView: UIView {

    struct Props: Equatable {

    }

    // MARK: - Properties



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

    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    // MARK: - Public methods

    func render(props: Props) {

    }
}
