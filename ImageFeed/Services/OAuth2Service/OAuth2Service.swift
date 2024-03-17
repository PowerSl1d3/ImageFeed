//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.04.2023.
//

import Foundation

final class OAuth2Service {
    private let urlSession = URLSession.shared

    private var task: URLSessionTask?
    private var lastCode: String?

    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }

    func fetchOAuthToken(
        with code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        if !Thread.isMainThread {
            assertionFailure("Code was called from non-main thread")
        }

        guard lastCode != code else { return }
        task?.cancel()
        lastCode = code
        let request: URLRequest
        do {
            request = try authTokenRequest(code: code)
        } catch {
            completion(.failure(error))

            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }

            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
