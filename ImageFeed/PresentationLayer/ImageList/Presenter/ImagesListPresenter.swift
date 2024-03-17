//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

final class ImagesListPresenter {
    weak var view: ImagesListViewInput?
    let stateStorage: ImagesListStateStorage
    let router: ImagesListRouterInput
    let imagesListService: ImagesListServiceProtocol

    private var imagesListServiceObserver: NSObjectProtocol?

    init(
        view: ImagesListViewInput? = nil,
        stateStorage: ImagesListStateStorage,
        router: ImagesListRouterInput,
        imagesListService: ImagesListServiceProtocol,
        imagesListServiceObserver: NSObjectProtocol? = nil
    ) {
        self.view = view
        self.stateStorage = stateStorage
        self.router = router
        self.imagesListService = imagesListService
        self.imagesListServiceObserver = imagesListServiceObserver
    }
}

extension ImagesListPresenter: ImagesListViewOutput {
    var photos: Photos {
        get {
            stateStorage.photos
        }
        set {
            stateStorage.photos = newValue
        }
    }

    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                updateTableViewAnimated()
            }

        imagesListService.fetchPhotosNextPage()
    }

    func didSelectRow(at indexPath: IndexPath) {
        router.presentSingleImage(withPhoto: stateStorage.photos[indexPath.row])
    }

    func tableViewWillDisplayCell(at indexPath: IndexPath) {
        guard indexPath.row + 1 == photos.count else { return }
        imagesListService.fetchPhotosNextPage()
    }
}

extension ImagesListPresenter {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}

extension ImagesListPresenter: ImageListCellDelegate {
    func didTapLikeButton(cell: ImageListCell, cellModel: Photo?) {
        guard let cellModel,
              let photoIndex = photos.firstIndex(where: { $0.id == cellModel.id }) else {
            return
        }
        cell.isLikeButtonUserInteractionEnabled = false

        imagesListService.changeLike(
            photoId: cellModel.id,
            isLike: !cellModel.isLiked
        ) { [weak self, weak cell] result in
            defer { cell?.isLikeButtonUserInteractionEnabled = true }

            guard let self, let cell, case .success = result else { return }

            let photo = photos[photoIndex]
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: !photo.isLiked
            )
            self.photos[photoIndex] = newPhoto
            cell.setIsLiked(newPhoto.isLiked)
        }
    }
}
