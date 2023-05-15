//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 21.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private enum StorageKeys {
        static let token = "token"
    }

    private let keychain = KeychainWrapper.standard

    var token: String? {
        get {
            keychain.string(forKey: StorageKeys.token)
        }
        set {
            if let newValue {
                keychain.set(newValue, forKey: StorageKeys.token)
            } else {
                keychain.removeObject(forKey: StorageKeys.token)
            }
        }
    }
}
