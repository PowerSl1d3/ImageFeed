//
//  WebViewOutput.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 19.04.2023.
//

import Foundation

protocol WebViewOutput {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?

    // TODO: так не совсем правильно, но пока что пусть будет так
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewController)
}
