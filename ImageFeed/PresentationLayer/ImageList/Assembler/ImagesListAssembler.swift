//
//  ImagesListAssembler.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

final class ImagesListAssembler {
    static func assemble() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else {
            return UIViewController()
        }

        let presenter = ImagesListPresenter()
        presenter.view = imagesListViewController
        imagesListViewController.viewOutput = presenter

        return imagesListViewController
    }
}
