//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }

    func fetchProfileImage(
        _ username: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
}
