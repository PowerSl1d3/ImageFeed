//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 10.05.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: Date?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult

    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

typealias PhotosResult = [PhotoResult]

