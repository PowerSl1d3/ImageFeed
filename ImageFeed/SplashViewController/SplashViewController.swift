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

    private var alertPresenter: AlertPresenterProtocol! = AlertPresenter()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.addSubview(splashLogo)

        setupViews()
        setupConstraints()
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
        let authViewController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(withIdentifier: "AuthViewController")

        guard let authViewController = authViewController as? AuthViewController else {
            return
        }

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
            case .failure:
                self.oauth2TokenStorage.token = nil
                UIBlockingProgressHUD.dismiss()
                let alertModel = AlertModel(
                    title: "Что-то пошло не так:(",
                    message: "Не удалось войти в систему",
                    buttonText: "Ок"
                )
                self.alertPresenter.show(alertModel: alertModel, presentingViewController: authViewController)
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

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")

        window.rootViewController = tabBarController
    }
}
