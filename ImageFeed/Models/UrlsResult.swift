//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 10.05.2023.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
