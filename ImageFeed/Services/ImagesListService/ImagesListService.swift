//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 09.05.2023.
//

import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private(set) var photos = Photos()
    private var lastLoadedPage: Int?
    private var lastPageLoaded: Bool = false

    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var fetchImagesTask: URLSessionTask?
    private var changeImageLikeTask: URLSessionTask?

    func fetchPhotosNextPage() {
        if !Thread.isMainThread {
            assertionFailure("Code was called from non-main thread")
        }

        guard fetchImagesTask == nil,
              let token = oauth2TokenStorage.token,
              lastPageLoaded == false else {
            return
        }

        let nextPage = (lastLoadedPage ?? 0) + 1
        let request: URLRequest
        do {
            request = try imagesListRequest(with: token, for: nextPage)
        } catch {
            assertionFailure("Something went wrong. Can't create \\photos request")
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotosResult, Error>) in
            guard let self else { return }

            switch result {
            case .success(let photosResult):
                photos.append(contentsOf: photosResult.map(Photo.init(photoResult:)))
                lastLoadedPage = (lastLoadedPage ?? 0) + 1
                NotificationCenter.default.post(name: Self.DidChangeNotification, object: nil)
            case .failure(let error):
                if let error = error as? NetworkError,
                   case .httpStatusCode(let statusCode) = error,
                   statusCode >= 500 {
                    self.lastPageLoaded = true
                }
            }

            self.fetchImagesTask = nil
        }
        self.fetchImagesTask = task
        task.resume()
    }

    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        if !Thread.isMainThread {
            assertionFailure("Code was called from non-main thread")
        }

        guard changeImageLikeTask == nil, let token = oauth2TokenStorage.token else { return }

        let request: URLRequest
        do {
            request = try imageLikeRequest(with: token, photoId: photoId, isLiked: isLike)
        } catch {
            assertionFailure("Something went wrong. Can't create \\photos\\<id>\\like request")
            return
        }

        let changeImageLikeTask = urlSession.dataTask(for: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }

            self.changeImageLikeTask = nil
        }
        self.changeImageLikeTask = changeImageLikeTask
        changeImageLikeTask.resume()
    }
}
