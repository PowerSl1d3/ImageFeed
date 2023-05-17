//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 17.05.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
