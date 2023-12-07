//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 05.03.2023.
//

import UIKit
import Kingfisher
import SnapKit

final class ProfileViewController: UIViewController {

    var viewOutput: ProfileViewOutput?
    var didSetupConstraints = false

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .anonymAvatar))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35

        return imageView
    }()

    private let exitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .ypRed
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.accessibilityIdentifier = "ProfileExitButton"

        return button
    }()

    private let profileTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .ypBoldFont(ofSize: 23)
        label.textColor = .ypWhite
        label.text = "Екатерина Новикова"

        return label
    }()

    private let profileSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .ypMediumFont(ofSize: 13)
        label.textColor = .ypGray
        label.text = "@ekaterina_nov"

        return label
    }()

    private let profileDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .ypMediumFont(ofSize: 13)
        label.textColor = .ypWhite
        label.text = "Hello, world!"
        label.numberOfLines = 0

        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        viewOutput?.viewDidLoad()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }
}

extension ProfileViewController: ProfileViewInput {
    func updateProfileDetails(profile: Profile) {
        profileTitleLabel.text = profile.username
        profileSubtitleLabel.text = profile.loginName
        profileDescriptionLabel.text = profile.bio
    }

    func updateAvatar(with url: URL) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url)
    }
}

private extension ProfileViewController {
    func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.size.equalTo(70)
        }

        exitButton.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(20)
            make.height.equalTo(22)
        }

        profileTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.leading)
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
        }

        profileSubtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.leading)
            make.top.equalTo(profileTitleLabel.snp.bottom).offset(8)
        }

        profileDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(profileSubtitleLabel.snp.bottom).offset(8)
        }
    }

    func setupViews() {
        exitButton.addTarget(self, action: #selector(didTapProfileExitButton), for: .touchUpInside)

        view.addSubview(avatarImageView)
        view.addSubview(exitButton)
        view.addSubview(profileTitleLabel)
        view.addSubview(profileSubtitleLabel)
        view.addSubview(profileDescriptionLabel)

        view.backgroundColor = .ypBlack
        view.setNeedsUpdateConstraints()
    }

    func setupTabBarItem() {
        tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
    }
}

// MARK: Actions
private extension ProfileViewController {
    @objc func didTapProfileExitButton() {
        viewOutput?.didTapProfileExitButton()
    }
}
