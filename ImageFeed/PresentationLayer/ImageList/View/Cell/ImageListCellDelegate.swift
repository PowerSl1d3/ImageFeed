//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 11.05.2023.
//

protocol ImageListCellDelegate: AnyObject {
    func didTapLikeButton(cell: ImageListCell, cellModel: Photo?)
}
