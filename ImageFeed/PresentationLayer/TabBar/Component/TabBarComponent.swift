//
//  TabBarComponent.swift
//  ImageFeed
//
//  Created by Oleg Aksenenko on 11.01.2024.
//

import NeedleFoundation
import UIKit

protocol TabBarDependency: Dependency {
    var imagesListComponent: ImagesListComponent { get }
    var profileComponent: ProfileComponent { get }
}

final class TabBarComponent: Component<TabBarDependency> {
    var tabBarcontroller: TabBarController {
        let viewController = TabBarController()

        viewController.imagesListViewController = dependency.imagesListComponent.imagesListViewController
        viewController.profileViewController = dependency.profileComponent.profileViewController

        return viewController
    }
}
