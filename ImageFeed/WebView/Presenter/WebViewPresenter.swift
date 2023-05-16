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
}

extension WebViewPresenter: WebViewOutput {
    func viewDidLoad() {
        var urlComponents = URLComponents(
            url: UnsplashAPIGlobalConstants.unsplashAuthorizeURL,
            resolvingAgainstBaseURL: true
        )

        urlComponents?.queryItems = [
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.clientId,
                value: UnsplashAPIGlobalConstants.QueryValues.accessKey
            ),
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.redirectURI,
                value: UnsplashAPIGlobalConstants.QueryValues.redirectURI
            ),
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.responseType,
                value: UnsplashAPIGlobalConstants.QueryValues.responseType
            ),
            URLQueryItem(
                name: UnsplashAPIGlobalConstants.QueryKeys.scope,
                value: UnsplashAPIGlobalConstants.QueryValues.accessScope
            )
        ]

        guard let url = urlComponents?.url else { return }
        let request = URLRequest(url: url)

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
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        }

        return nil
    }

    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        moduleOutput?.webViewViewController(vc, didAuthenticateWithCode: code)
    }

    func webViewControllerDidCancel(_ vc: WebViewController) {
        moduleOutput?.webViewControllerDidCancel(vc)
    }
}

private extension WebViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
