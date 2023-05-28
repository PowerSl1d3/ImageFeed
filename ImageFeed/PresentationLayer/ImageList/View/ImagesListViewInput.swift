//
//  ImagesListViewInput.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

protocol ImagesListViewInput: AnyObject {
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}
