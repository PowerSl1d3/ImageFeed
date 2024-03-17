//
//  SplashViewControllerAssembly.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 09.12.2023.
//

import UIKit
import Swinject
import NeedleFoundation

final class SplashViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SplashViewController.self) { resolver in
            let viewController = SplashViewController()
            let stateStorage = SplashStateStorage()
            let presenter = SplashPresenter()
//            let router = SplashRouter()

            viewController.viewOutput = presenter

            let alertPresenter = AlertPresenterService(viewController: viewController)

            presenter.view = viewController
//            presenter.router = router
            presenter.stateStorage = stateStorage
            presenter.alertPresenter = alertPresenter

//            router.resolver = resolver
//            router.output = presenter
//            router.viewController = viewController

            return viewController
        }
    }
}
