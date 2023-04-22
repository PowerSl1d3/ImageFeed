//
//  URLRequest+Unsplash.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.04.2023.
//

import Foundation

fileprivate enum HTTPMethods {
    static let GET = "GET"
    static let POST = "POST"
    static let PUT = "PUT"
    static let DELETE = "DELETE"
}

enum URLRequestError: Error {
    case requestCreateError
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = UnsplashAPIGlobalConstants.defaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

func authTokenRequest(code: String) -> URLRequest? {
    guard let url = URL(string: "https://unsplash.com") else { return nil }

    return URLRequest.makeHTTPRequest(
        path: "/oauth/token"
        + "?\(UnsplashAPIGlobalConstants.QueryKeys.clientId)=\(UnsplashAPIGlobalConstants.QueryValues.accessKey)"
        + "&&\(UnsplashAPIGlobalConstants.QueryKeys.cleintSecret)=\(UnsplashAPIGlobalConstants.QueryValues.secretKey)"
        + "&&\(UnsplashAPIGlobalConstants.QueryKeys.redirectURI)=\(UnsplashAPIGlobalConstants.QueryValues.redirectURI)"
        + "&&\(UnsplashAPIGlobalConstants.QueryKeys.code)=\(code)"
        + "&&\(UnsplashAPIGlobalConstants.QueryKeys.grantType)=\(UnsplashAPIGlobalConstants.QueryValues.authorizationCode)",
        httpMethod: HTTPMethods.POST,
        baseURL: url
    )
}
