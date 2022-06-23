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
        let recipesHeaderViewProps: ProfileRecipesHeaderView.Props
        let infoViewProps: ProfileInfoView.Props
    }

    // MARK: - Properties

    let headerView = ProfileHeaderView()
    let recipesHeaderView = ProfileRecipesHeaderView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    let infoView = ProfileInfoView()

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
        let stackView = UIStackView(arrangedSubviews: [headerView, recipesHeaderView, infoView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(24, after: headerView)
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            recipesHeaderView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            infoView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -140)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerViewProps)
        recipesHeaderView.render(props: props.recipesHeaderViewProps)
        infoView.render(props: props.infoViewProps)
    }
}
