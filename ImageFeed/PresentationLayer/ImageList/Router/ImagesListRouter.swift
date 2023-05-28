//
//  ImagesListRouter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

final class ImagesListRouter: ImagesListRouterInput {
    func prepareForShowSingleImage(
        for segue: UIStoryboardSegue,
        sender: Any?,
        photos: Photos
    ) {
        if let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            let imageUrl = photos[indexPath.row].largeImageURL
            viewController.imageUrl = imageUrl
        }
    }
}
