//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.04.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private enum StorageKeys {
        static let token = "token"
    }

    let userDefault = UserDefaults.standard

    var token: String? {
        get {
            userDefault.string(forKey: StorageKeys.token)
        }
        set {
            userDefault.set(newValue, forKey: StorageKeys.token)
        }
    }
}
