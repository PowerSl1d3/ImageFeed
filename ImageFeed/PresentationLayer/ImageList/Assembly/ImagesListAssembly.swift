//
//  ImagesListAssembly.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit
import Swinject

final class ImagesListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ImagesListViewController.self) { _ in
            let imagesListViewController = ImagesListViewController()
//            let router = ImagesListRouter()
//            let presenter = ImagesListPresenter()
//
//            presenter.view = imagesListViewController
//            presenter.router = router
//            router.rootViewController = imagesListViewController
//            imagesListViewController.viewOutput = presenter

            return imagesListViewController
        }
    }
}
