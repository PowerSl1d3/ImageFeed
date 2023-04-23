//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 05.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AnonymAvatar"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.contentMode = .scaleAspectFit

        return button
    }()

    private let profileTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "YSDisplay-Bold", size: 23)
        label.textColor = .ypWhite
        label.text = "Екатерина Новикова"

        return label
    }()

    private let profileSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "YSDisplay-Medium", size: 13)
        label.textColor = .ypGray
        label.text = "@ekaterina_nov"

        return label
    }()

    private let profileDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "YSDisplay-Medium", size: 13)
        label.textColor = .ypWhite
        label.text = "Hello, world!"

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(avatarImageView)
        view.addSubview(exitButton)
        view.addSubview(profileTitleLabel)
        view.addSubview(profileSubtitleLabel)
        view.addSubview(profileDescriptionLabel)

        setupConstraints()
    }
}

private extension ProfileViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            avatarImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            exitButton.widthAnchor.constraint(equalToConstant: 20),
            exitButton.heightAnchor.constraint(equalToConstant: 22)
        ])

        NSLayoutConstraint.activate([
            profileTitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            profileTitleLabel.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 8
            )
        ])

        NSLayoutConstraint.activate([
            profileSubtitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            profileSubtitleLabel.topAnchor.constraint(
                equalTo: profileTitleLabel.bottomAnchor,
                constant: 8
            )
        ])

        NSLayoutConstraint.activate([
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            profileDescriptionLabel.topAnchor.constraint(
                equalTo: profileSubtitleLabel.bottomAnchor,
                constant: 8
            )
        ])
    }
}
