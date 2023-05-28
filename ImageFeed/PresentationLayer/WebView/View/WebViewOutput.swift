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

    func didAuthenticate(with code: String)
    func didTapCloseButton()
}
