//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.05.2023.
//

protocol ProfileServiceProtocol {
    var profile: Profile? { get }

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    )
}
