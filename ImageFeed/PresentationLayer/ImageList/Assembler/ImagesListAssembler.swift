//
//  ImagesListAssembler.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

final class ImagesListAssembler {
    static func assemble() -> UIViewController {
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "TabImageListActive"),
            selectedImage: nil
        )

        let router = ImagesListRouter()
        let presenter = ImagesListPresenter()
        presenter.view = imagesListViewController
        presenter.router = router
        router.rootViewController = imagesListViewController
        imagesListViewController.viewOutput = presenter

        return imagesListViewController
    }
}
