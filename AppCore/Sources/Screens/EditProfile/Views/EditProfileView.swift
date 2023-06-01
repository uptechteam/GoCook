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
    }

    private func setupContentView() {
        backgroundColor = .white
    }

    // MARK: - Public methods

    func render(props: Props) {

    }
}
