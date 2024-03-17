//
//  ImagesListComponent.swift
//  ImageFeed
//
//  Created by Oleg Aksenenko on 12.01.2024.
//

import NeedleFoundation
import UIKit

protocol ImagesListDependency: Dependency {
    var servicesProviderComponent: ServicesProviderComponent { get }
}

final class ImagesListComponent: Component<ImagesListDependency> {
    var imagesListViewController: UIViewController {
        let imagesListViewController = ImagesListViewController()

        let router = ImagesListRouter(rootViewController: imagesListViewController)

        let presenter = ImagesListPresenter(
            view: imagesListViewController,
            stateStorage: ImagesListStateStorage(),
            router: router,
            imagesListService: dependency.servicesProviderComponent.imageListService
        )

        imagesListViewController.viewOutput = presenter

        return imagesListViewController
    }
}
