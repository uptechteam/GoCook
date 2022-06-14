//
//  InputTextField.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

public final class InputTextField: UITextField {

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

    }

    // MARK: - Public methods

    func render(props: Props) {

    }
}
