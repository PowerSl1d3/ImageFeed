//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.05.2023.
//

import UIKit

final class ImagesListPresenter {
    weak var view: ImagesListViewInput!
    var stateStorage: ImagesListStateStorage = ImagesListStateStorage()
    var router: ImagesListRouterInput = ImagesListRouter()
    var imagesListService: ImagesListServiceProtocol = ImagesListService()

    private var imagesListServiceObserver: NSObjectProtocol?
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

    func prepareShowSingleImage(for segue: UIStoryboardSegue, sender: Any?) {
        router.prepareForShowSingleImage(for: segue, sender: sender, photos: stateStorage.photos)
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
            view.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}

extension ImagesListPresenter: ImageListCellDelegate {
    func didTapLikeButton(cell: ImageListCell, cellModel: Photo?) {
        guard let cellModel,
              let photoIndex = photos.firstIndex(where: { $0.id == cellModel.id }) else {
            return
        }
        cell.likeButton.isUserInteractionEnabled = false

        imagesListService.changeLike(
            photoId: cellModel.id,
            isLike: !cellModel.isLiked
        ) { [weak self, weak cell] result in
            defer { cell?.likeButton.isUserInteractionEnabled = true }

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
