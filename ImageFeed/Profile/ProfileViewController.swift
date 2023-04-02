//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 05.03.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Avatar"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    let exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Color.ypRed
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.contentMode = .scaleAspectFit

        return button
    }()

    let profileTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 23)
        label.textColor = Color.ypWhite
        label.text = "Екатерина Новикова"

        return label
    }()

    let profileSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.textColor = Color.ypGray
        label.text = "@ekaterina_nov"

        return label
    }()

    let profileDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.textColor = Color.ypWhite
        label.text = "Hello, world!"

        return label
    }()

    override func viewDidLoad() {
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
