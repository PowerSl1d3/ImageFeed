//
//  SplashRouter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 12.12.2023.
//

import UIKit
import Swinject

final class SplashRouter {
    var resolver: Resolver!
    weak var output: SplashRouterOutput?
    weak var viewController: UIViewController?
}

extension SplashRouter: SplashRouterInput {
    func performAuthorizationFlow() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen

        viewController?.present(authViewController, animated: false)
    }

    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")

            return
        }

        let tabBarController = resolver.resolve(TabBarController.self)!
        window.rootViewController = tabBarController

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}

extension SplashRouter: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }

            output?.authViewControllerDidAuthenticate(with: code, vc)
        }
    }
}
