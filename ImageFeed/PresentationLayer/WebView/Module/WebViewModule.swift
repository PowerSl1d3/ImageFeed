//
//  WebViewModule.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 17.05.2023.
//

import Foundation

protocol WebViewModule {
    var moduleOutput: WebViewModuleOutput? { get set }
}

protocol WebViewModuleOutput: AnyObject {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewController)
}
