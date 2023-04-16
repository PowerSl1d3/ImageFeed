//
//  Constants.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 15.04.2023.
//

import Foundation

struct Constants {
    static let accessKey = "fnkCxiaYkxu28fow842cwVWyf12ggb2FskpEo357AJQ"
    static let secretKey = "E7p577hlmw3DKY3d5lM-2k7MetZaNkcdNShDpjvyBPI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"

    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}
