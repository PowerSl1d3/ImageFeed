//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 22.04.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let splashLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "PracticumLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()

    private var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    private var error: Error?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(splashLogo)

        alertPresenter.viewController = self
        setupViews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Если не удалось произвести авторизацию, то остаёмся на этом контроллере с алертом и просим попробовать
        // попробовать авторизоваться ещё раз
        guard error == nil else {
            error = nil

            return
        }

        if let token = oauth2TokenStorage.token {
            fetchProfile(with: token)
        } else {
            performAuthorizationFlow()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension SplashViewController {
    func performAuthorizationFlow() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen

        present(authViewController, animated: false)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code, authViewController: vc)
        }
    }

    private func fetchOAuthToken(_ code: String, authViewController: UIViewController) {
        oauth2Service.fetchOAuthToken(with: code) { [weak self, weak authViewController] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(with: token)
            case .failure(let error):
                self.error = error
                self.oauth2TokenStorage.token = nil
                UIBlockingProgressHUD.dismiss()
                authViewController?.dismiss(animated: true)

                var alertModel = AlertModel(
                    title: "Что-то пошло не так:(",
                    message: "Не удалось войти в систему",
                    successfulButtonText: "Ок"
                )

                alertModel.successfulCompletion = {
                    self.performAuthorizationFlow()
                }

                self.alertPresenter.show(alertModel: alertModel)
            }
        }
    }
}

private extension SplashViewController {
    func setupViews() {
        view.backgroundColor = .ypBlack
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            splashLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func fetchProfile(with token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImage(profile.username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                assertionFailure("Something went wrong. Can't get profile information")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")

            return
        }

        let tabBarController = TabBarController()
        window.rootViewController = tabBarController

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
