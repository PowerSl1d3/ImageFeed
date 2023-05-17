//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 18.05.2023.
//

import Foundation

final class AuthHelper {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }
}

extension AuthHelper: AuthHelperProtocol {
    func authRequest() -> URLRequest {
        let authURL: URL

        do {
            authURL = try self.authURL()
        } catch {
            preconditionFailure("Something went wrong. Can't create WebView request")
        }

        return URLRequest(url: authURL)
    }

    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        }

        return nil
    }
}

private extension AuthHelper {
    func authURL() throws -> URL {
        var urlComponents = URLComponents(
            url: configuration.authURL,
            resolvingAgainstBaseURL: true
        )

        urlComponents?.queryItems = [
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.clientId,
                value: configuration.accessKey
            ),
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.redirectURI,
                value: configuration.redirectURI
            ),
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.responseType,
                value: UnsplashAPIGlobalConstants.QueryValues.responseType
            ),
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.scope,
                value: configuration.accessScope
            )
        ]

        guard let urlComponents,
              let url = urlComponents.url else {
            throw URLRequestError.requestCreateError
        }

        return url
    }
}
