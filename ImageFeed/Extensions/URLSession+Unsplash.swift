//
//  URLSession+Unsplash.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 20.04.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func dataTask(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = dataTask(with: request) { data, response, error in
            if let data,
               let response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }

        return task
    }
}

extension URLSession {
    func objectTask<ResultObject: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<ResultObject, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return dataTask(for: request) { result in
            let response = result.flatMap { data in
                Result {
                    try decoder.decode(ResultObject.self, from: data)
                }
            }
            completion(response)
        }
    }
}
