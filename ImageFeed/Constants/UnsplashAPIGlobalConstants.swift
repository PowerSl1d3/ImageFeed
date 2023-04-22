//
//  UnsplashAPIGlobalConstants.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 15.04.2023.
//

import Foundation

struct UnsplashAPIGlobalConstants {
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!

    enum QueryKeys {
        static let clientId = "client_id"
        static let cleintSecret = "client_secret"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let scope = "scope"
        static let code = "code"
        static let grantType = "grant_type"
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