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

        let task = object(for: request) { [weak self] result in
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

private extension ProfileService {
    func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionDataTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { result in
            let response = result.flatMap { data in
                Result {
                    try decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
