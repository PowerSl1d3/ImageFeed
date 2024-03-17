//
//  ImagesListRouter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

final class ImagesListRouter: ImagesListRouterInput {
    weak var rootViewController: UIViewController?

    init(rootViewController: UIViewController? = nil) {
        self.rootViewController = rootViewController
    }

    func presentSingleImage(withPhoto photo: Photo) {
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.imageUrl = photo.largeImageURL
        singleImageViewController.modalPresentationStyle = .fullScreen

        rootViewController?.present(singleImageViewController, animated: true)
    }
}
