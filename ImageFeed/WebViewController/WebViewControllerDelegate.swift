//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 19.04.2023.
//

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewController)
}
