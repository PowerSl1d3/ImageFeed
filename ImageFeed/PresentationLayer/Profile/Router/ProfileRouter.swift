//
//  ProfileRouter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

import UIKit

final class ProfileRouter {
    weak var view: UIViewController?
    let alertPresenter: AlertPresenterServiceProtocol
    let builder: ProfileBuilder

    init(view: UIViewController? = nil, alertPresenter: AlertPresenterServiceProtocol, builder: ProfileBuilder) {
        self.view = view
        self.alertPresenter = alertPresenter
        self.builder = builder
    }
}

extension ProfileRouter: ProfileRouterInput {
    func switchToSplashController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")

            return
        }

        let splashViewController = builder.splashViewController
        window.rootViewController = splashViewController

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }

    func showProfileExitAlert(
        successfullCompletion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) {
        var alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            successfulButtonText: "Да",
            cancelButtonText: "Нет"
        )

        alertModel.successfulCompletion = successfullCompletion
        alertModel.cancelCompletion = cancelCompletion

        alertPresenter.show(alertModel: alertModel)
    }
}
