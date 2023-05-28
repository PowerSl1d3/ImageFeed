//
//  ProfileRouter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

import UIKit

final class ProfileRouter: ProfileRouterInput {
    weak var view: UIViewController?
    var alertPresenter: AlertPresenterProtocol?

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

        alertPresenter?.show(alertModel: alertModel)
    }
}
