//
//  ImagesListViewOutput.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

protocol ImagesListViewOutput {
    var photos: Photos { get }

    func viewDidLoad()
    func prepareShowSingleImage(for segue: UIStoryboardSegue, sender: Any?)
    func tableViewWillDisplayCell(at indexPath: IndexPath)
}
