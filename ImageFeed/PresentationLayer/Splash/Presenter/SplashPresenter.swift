//
//  SplashPresenter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 11.12.2023.
//

import UIKit

final class SplashPresenter {
    weak var view: SplashViewInput?
    var router: SplashRouterInput!
    var stateStorage: SplashStateStorage!

    var alertPresenter: AlertPresenterServiceProtocol!

    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
}

extension SplashPresenter: SplashViewOutput {
    func viewDidAppear() {
        // Если не удалось произвести авторизацию, то остаёмся на этом контроллере с алертом и просим попробовать
        // попробовать авторизоваться ещё раз
        guard stateStorage.authError == nil else {
            stateStorage.authError = nil

            return
        }

        if let token = oauth2TokenStorage.token {
            fetchProfile(with: token)
        } else {
            router.performAuthorizationFlow()
        }
    }
}

extension SplashPresenter: SplashRouterOutput {
    func authViewControllerDidAuthenticate(with code: String, _ vc: UIViewController) {
        view?.showProgressHUD()
        fetchOAuthToken(code, authViewController: vc)
    }
}

private extension SplashPresenter {
    func fetchProfile(with token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImage(profile.username) { _ in }
                view?.hideProgressHUD()
                router.switchToTabBarController()
            case .failure:
                assertionFailure("Something went wrong. Can't get profile information")
                view?.hideProgressHUD()
            }
        }
    }

    private func fetchOAuthToken(_ code: String, authViewController: UIViewController) {
        oauth2Service.fetchOAuthToken(with: code) { [weak self, weak authViewController] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                fetchProfile(with: token)
            case .failure(let error):
                stateStorage.authError = error
                oauth2TokenStorage.token = nil
                view?.hideProgressHUD()
                authViewController?.dismiss(animated: true)

                var alertModel = AlertModel(
                    title: "Что-то пошло не так:(",
                    message: "Не удалось войти в систему",
                    successfulButtonText: "Ок"
                )

                alertModel.successfulCompletion = { [weak self] in
                    self?.router.performAuthorizationFlow()
                }

                alertPresenter.show(alertModel: alertModel)
            }
        }
    }
}
