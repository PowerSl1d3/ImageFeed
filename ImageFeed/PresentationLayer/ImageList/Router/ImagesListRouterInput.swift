//
//  ImagesListRouterInput.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

protocol ImagesListRouterInput {
    func prepareForShowSingleImage(
        for segue: UIStoryboardSegue,
        sender: Any?,
        photos: Photos
    )
}
