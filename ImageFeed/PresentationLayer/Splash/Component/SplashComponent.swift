//
//  SplashComponent.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 25.12.2023.
//

import NeedleFoundation
import UIKit

protocol SplashDependency: Dependency {
    var servicesProviderComponent: ServicesProviderComponent { get }
    var tabBarComponent: TabBarComponent { get }
}

protocol SplashBuilder {
    var authViewController: AuthViewController { get }
    var tabBarController: TabBarController { get }
}

final class SplashComponent: Component<SplashDependency>, SplashBuilder {
    var splashViewController: SplashViewController {
        let viewController = SplashViewController()
        let stateStorage = SplashStateStorage()
        let presenter = SplashPresenter()
        let router = SplashRouter(builder: self)

        viewController.viewOutput = presenter

        let alertPresenter = dependency.servicesProviderComponent.alertPresenterService

        presenter.view = viewController
        presenter.router = router
        presenter.stateStorage = stateStorage
        presenter.alertPresenter = alertPresenter

//        router.resolver = ...
        router.output = presenter
        router.viewController = viewController

        return viewController
    }

    var authViewController: AuthViewController {
        AuthViewController()
    }

    var tabBarController: TabBarController {
        dependency.tabBarComponent.tabBarcontroller
    }
}
