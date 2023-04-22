//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 22.04.2023.
//

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
