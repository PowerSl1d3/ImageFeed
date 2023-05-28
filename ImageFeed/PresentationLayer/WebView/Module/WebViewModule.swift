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
    func didAuthenticate(with code: String)
    func didTapCloseButton()
}
