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
        baseURL: URL = UnsplashAPIGlobalConstants.defaultBaseAPIURL
    ) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw(URLRequestError.requestCreateError)
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

func authTokenRequest(code: String) throws -> URLRequest {
    let queryParams = [
        UnsplashAPIGlobalConstants.QueryKeys.clientId: UnsplashAPIGlobalConstants.QueryValues.accessKey,
        UnsplashAPIGlobalConstants.QueryKeys.cleintSecret: UnsplashAPIGlobalConstants.QueryValues.secretKey,
        UnsplashAPIGlobalConstants.QueryKeys.redirectURI: UnsplashAPIGlobalConstants.QueryValues.redirectURI,
        UnsplashAPIGlobalConstants.QueryKeys.code: code,
        UnsplashAPIGlobalConstants.QueryKeys.grantType: UnsplashAPIGlobalConstants.QueryValues.authorizationCode
    ]

    return try URLRequest.makeHTTPRequest(
        path: addQueryParams(queryParams, toRelativePath: "/oauth/token"),
        httpMethod: HTTPMethods.POST,
        baseURL: UnsplashAPIGlobalConstants.defaultBaseURL
    )
}

func profileRequest(with token: String) throws -> URLRequest {
    var request = try URLRequest.makeHTTPRequest(
        path: UnsplashAPIGlobalConstants.profilePath,
        httpMethod: HTTPMethods.GET
    )
    request.setValue("Bearer \(token)", forHTTPHeaderField: UnsplashAPIGlobalConstants.HeaderFields.authorization)

    return request
}

func profileImageRequest(with username: String, token: String) throws -> URLRequest {
    var request = try URLRequest.makeHTTPRequest(
        path: UnsplashAPIGlobalConstants.profileImagePath + username,
        httpMethod: HTTPMethods.GET
    )
    request.setValue("Bearer \(token)", forHTTPHeaderField: UnsplashAPIGlobalConstants.HeaderFields.authorization)

    return request
}

func imagesListRequest(with token: String, for page: Int) throws -> URLRequest {
    let queryParams = [
        UnsplashAPIGlobalConstants.QueryKeys.page: String(page)
    ]

    var request = try URLRequest.makeHTTPRequest(
        path: addQueryParams(queryParams, toRelativePath: UnsplashAPIGlobalConstants.imagesListPath),
        httpMethod: HTTPMethods.GET
    )
    request.setValue("Bearer \(token)", forHTTPHeaderField: UnsplashAPIGlobalConstants.HeaderFields.authorization)

    return request
}

func imageLikeRequest(with token: String, photoId: String, isLiked: Bool) throws -> URLRequest {
    var request = try URLRequest.makeHTTPRequest(
        path: String(format: UnsplashAPIGlobalConstants.likePhotoPath, photoId),
        httpMethod: isLiked ? HTTPMethods.POST : HTTPMethods.DELETE
    )
    request.setValue("Bearer \(token)", forHTTPHeaderField: UnsplashAPIGlobalConstants.HeaderFields.authorization)

    return request
}

fileprivate func addQueryParams(_ queryParams: [String: String], toRelativePath path: String) -> String {
    path + "?" + queryParams.map { (key, value) in
        key + "=" + value
    }.joined(separator: "&&")
}
