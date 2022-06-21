//
//  ProfileView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class ProfileView: UIView {

    struct Props: Equatable {
        let headerViewProps: ProfileHeaderView.Props
    }

    // MARK: - Properties

    let headerView = ProfileHeaderView()

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
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, UIView()])
        stackView.axis = .vertical
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerViewProps)
    }
}
