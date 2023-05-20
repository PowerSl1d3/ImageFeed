//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

import UIKit
import WebKit

final class ProfilePresenter {
    // MARK: - Public
    weak var view: ProfileViewInput?
    var router: ProfileRouterInput?

    // MARK: Services
    var profileService: ProfileServiceProtocol = ProfileService.shared
    var profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared

    // MARK: - Private
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
}

extension ProfilePresenter: ProfileViewOutput {
    func viewDidLoad() {
        guard let profile = profileService.profile else {
            assertionFailure("Something went wrong. Profile in ProfileService was nil")

            return
        }
        view?.updateProfileDetails(profile: profile)

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                updateAvatar()
            }
        updateAvatar()
    }

    func didTapProfileExitButton() {
        router?.showProfileExitAlert() { [weak self] in
            guard let self else { return }

            oauth2TokenStorage.token = nil
            WKWebView.clean()
            router?.switchToSplashController()
        } cancelCompletion: {
        }
    }
}

private extension ProfilePresenter {
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else {
            return
        }

        view?.updateAvatar(with: url)
    }
}
