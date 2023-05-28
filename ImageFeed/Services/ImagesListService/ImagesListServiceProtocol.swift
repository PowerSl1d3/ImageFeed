//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

protocol ImagesListServiceProtocol {
    var photos: Photos { get }

    func fetchPhotosNextPage()
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    )
}
