//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 17.05.2023.
//

import Foundation

final class WebViewPresenter: WebViewModule {
    weak var view: WebViewInput?
    weak var moduleOutput: WebViewModuleOutput?
    var authHelper: AuthHelperProtocol

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
}

extension WebViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

extension WebViewPresenter: WebViewOutput {
    func viewDidLoad() {
        let request = authHelper.authRequest()
        didUpdateProgressValue(0.0)
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }

    func didAuthenticate(with code: String) {
        moduleOutput?.didAuthenticate(with: code)
    }

    func didTapCloseButton() {
        moduleOutput?.didTapCloseButton()
    }
}
