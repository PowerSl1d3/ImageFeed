//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 25.04.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        if !Thread.isMainThread {
            assertionFailure("Code was called from non-main thread")
        }

        guard task == nil else { return }
        let request: URLRequest
        do {
            request = try profileRequest(with: token)
        } catch {
            completion(.failure(error))

            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }

            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }

            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
