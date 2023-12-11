//
//  TabBarAssembly.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 07.12.2023.
//

import UIKit
import Swinject

final class TabBarAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TabBarController.self) { resolver in
            let viewController = TabBarController()

            viewController.imagesListViewController = resolver.resolve(ImagesListViewController.self)!
            viewController.profileViewController = resolver.resolve(ProfileViewController.self)!

            return viewController
        }
    }
}
