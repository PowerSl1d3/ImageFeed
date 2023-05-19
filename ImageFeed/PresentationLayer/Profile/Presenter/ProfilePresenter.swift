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

    // MARK: - Private
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var alertPresenter = AlertPresenter()
    private var profileImageServiceObserver: NSObjectProtocol?
}

extension ProfilePresenter: ProfileViewOutput {
    func viewDidLoad() {
        alertPresenter.viewController = view

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

    func didTapExitButton() {
        var alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            successfulButtonText: "Да",
            cancelButtonText: "Нет"
        )

        alertModel.successfulCompletion = { [weak self] in
            guard let self else { return }

            oauth2TokenStorage.token = nil
            WKWebView.clean()
            switchToSplashController()
        }

        alertModel.cancelCompletion = {}

        alertPresenter.show(alertModel: alertModel)
    }
}

private extension ProfilePresenter {
    func updateAvatar() {
        // Тоже в презентер выносим, не относится к слою вью
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else {
            return
        }

        view?.updateAvatar(with: url)
    }

    // Навигация тоже не относится к слою вью
    func switchToSplashController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")

            return
        }

        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
