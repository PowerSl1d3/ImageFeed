//
//  Profile.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 25.04.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?

    init(profileResult: ProfileResult) {
        username = profileResult.username

        if let lastName = profileResult.lastName {
            name = profileResult.firstName + " " + lastName
        } else {
            name = profileResult.firstName
        }

        loginName = "@" + profileResult.username
        bio = profileResult.bio
    }
}
