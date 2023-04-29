//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 22.04.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "showAuthViewController"

    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            fetchProfile(with: token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers.first as? AuthViewController else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")

                return
            }

            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(with: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(with: token)
            case .failure:
                // TODO [Sprint 11]
                break
            }
        }
    }
}

private extension SplashViewController {
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
