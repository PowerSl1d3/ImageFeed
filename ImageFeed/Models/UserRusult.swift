//
//  UserRusult.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 29.04.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImageResult

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImageResult: Decodable {
    let small: String
    let medium: String
    let large: String
}
