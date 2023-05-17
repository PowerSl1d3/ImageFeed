//
//  UnsplashAPIGlobalConstants.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 15.04.2023.
//

import Foundation

enum UnsplashAPIGlobalConstants {
    static let defaultBaseURL = URL(string: "https://unsplash.com")!
    static let defaultBaseAPIURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURL = URL(string: "/oauth/authorize", relativeTo: defaultBaseURL)!
    
    static let profilePath = "/me"
    static let profileImagePath = "/users/"
    static let imagesListPath = "/photos"
    static let likePhotoPath = "/photos/%@/like"

    enum HeaderFields {
        static let authorization = "Authorization"
    }

    enum QueryKeys {
        static let clientId = "client_id"
        static let cleintSecret = "client_secret"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let scope = "scope"
        static let code = "code"
        static let grantType = "grant_type"
        static let page = "page"
    }

    enum QueryValues {
        static let accessKey = "fnkCxiaYkxu28fow842cwVWyf12ggb2FskpEo357AJQ"
        static let secretKey = "E7p577hlmw3DKY3d5lM-2k7MetZaNkcdNShDpjvyBPI"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let responseType = "code"
        static let accessScope = "public+read_user+write_likes"
        static let authorizationCode = "authorization_code"
    }
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURL: URL

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: URL,
        authURL: URL
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURL = authURL
    }

    static var standart: AuthConfiguration {
        AuthConfiguration(
            accessKey: UnsplashAPIGlobalConstants.QueryValues.accessKey,
            secretKey: UnsplashAPIGlobalConstants.QueryValues.secretKey,
            redirectURI: UnsplashAPIGlobalConstants.QueryValues.redirectURI,
            accessScope: UnsplashAPIGlobalConstants.QueryValues.accessScope,
            defaultBaseURL: UnsplashAPIGlobalConstants.defaultBaseURL,
            authURL: UnsplashAPIGlobalConstants.unsplashAuthorizeURL
        )
    }
}
