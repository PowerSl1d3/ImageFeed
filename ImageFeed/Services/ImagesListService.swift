//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 09.05.2023.
//

import Foundation

final class ImagesListService {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?

    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    func fetchPhotosNextPage() {
        if !Thread.isMainThread {
            assertionFailure("Code was called from non-main thread")
        }

        guard task == nil, let token = oauth2TokenStorage.token else {
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
                NotificationCenter.default.post(name: Self.DidChangeNotification, object: nil)
            case .failure:
                assertionFailure("Something went wrong. Can't get images from UnsplashAPI")
            }

            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
