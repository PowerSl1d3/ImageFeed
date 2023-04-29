//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 29.04.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let urlSession = URLSession.shared

    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
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

        let task = object(for: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.small
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

private extension ProfileImageService {
    func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionDataTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { result in
            let response = result.flatMap { data in
                Result {
                    try decoder.decode(UserResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
