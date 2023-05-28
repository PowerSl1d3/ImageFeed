//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 29.04.2023.
//

import Foundation

final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()

    private(set) var authToken: String? {
        get {
            oauth2TokenStorage.token
        }
        set {
            oauth2TokenStorage.token = newValue
        }
    }

    private(set) var avatarURL: String?
    private var task: URLSessionTask?

    func fetchProfileImage(
        _ username: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        if !Thread.isMainThread {
            assertionFailure("Code was called from non-main thread")
        }

        guard task == nil else { return }

        guard let authToken else {
            assertionFailure("Authorization token was nil")

            return
        }

        let request: URLRequest
        do {
            request = try profileImageRequest(with: username, token: authToken)
        } catch {
            completion(.failure(error))

            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }

            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.large
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default.post(
                    name: Self.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL]
                )
            case .failure(let error):
                completion(.failure(error))
            }

            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
