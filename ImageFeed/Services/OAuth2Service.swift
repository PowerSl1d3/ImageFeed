//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.04.2023.
//

import Foundation

final class OAuth2Service {
    private let urlSession = URLSession.shared

    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }

    func fetchAuthToken(
        with code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let request = authTokenRequest(code: code) else {
            completion(.failure(URLRequestError.requestCreateError))
            return
        }

        let task = object(for: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

private extension OAuth2Service {
    func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionDataTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { result in
            let response = result.flatMap { data in
                Result {
                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
    }
}
