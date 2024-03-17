//
//  TabBarComponent.swift
//  ImageFeed
//
//  Created by Oleg Aksenenko on 11.01.2024.
//

import NeedleFoundation
import Swinject
import UIKit

protocol TabBarDependency: Dependency {
    var imagesListComponent: ImagesListComponent { get }
    var profileComponent: ProfileComponent { get }
}

final class TabBarComponent: Component<TabBarDependency> {
    convenience init() {
        self.init(parent: BootstrapComponent())
    }

    var tabBarcontroller: TabBarController {
        let viewController = TabBarController()

        viewController.imagesListViewController = dependency.imagesListComponent.imagesListViewController
        viewController.profileViewController = dependency.profileComponent.profileViewController

        return viewController
    }
}

extension TabBarComponent: Assembly {
    func assemble(container: Container) {
        container.register(TabBarController.self) { resolver in
            let viewController = TabBarController()

            viewController.imagesListViewController = resolver.resolve(ImagesListViewController.self)!
            viewController.profileViewController = resolver.resolve(ProfileViewController.self)!

            return viewController
        }
    }
}
