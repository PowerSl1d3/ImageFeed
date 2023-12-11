//
//  ProfileAssembly.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

import UIKit
import Swinject

final class ProfileAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfileViewController.self) { _ in
            let profileViewController = ProfileViewController()

            let router = ProfileRouter()
            router.view = profileViewController
            router.alertPresenter = AlertPresenter(viewController: profileViewController)

            let profilePresenter = ProfilePresenter()
            profileViewController.viewOutput = profilePresenter
            profilePresenter.view = profileViewController
            profilePresenter.router = router

            return profileViewController
        }
    }
}
