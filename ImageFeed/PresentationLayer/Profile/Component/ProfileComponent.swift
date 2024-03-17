//
//  ProfileComponent.swift
//  ImageFeed
//
//  Created by Oleg Aksenenko on 12.01.2024.
//

import NeedleFoundation
import UIKit

protocol ProfileDependency: Dependency {
    var servicesProviderComponent: ServicesProviderComponent { get }
    var splashComponent: SplashComponent { get }
}

protocol ProfileBuilder {
    var splashViewController: SplashViewController { get }
}

final class ProfileComponent: Component<ProfileDependency> {
    var profileViewController: ProfileViewController {
        let profileViewController = ProfileViewController()

        var alertPresenter = dependency.servicesProviderComponent.alertPresenterService
        alertPresenter.viewController = profileViewController

        let router = ProfileRouter(
            view: profileViewController,
            alertPresenter: alertPresenter,
            builder: self
        )

        let profilePresenter = ProfilePresenter()
        profileViewController.viewOutput = profilePresenter
        profilePresenter.view = profileViewController
        profilePresenter.router = router

        return profileViewController
    }
}

extension ProfileComponent: ProfileBuilder {
    var splashViewController: SplashViewController {
        dependency.splashComponent.splashViewController
    }
}
