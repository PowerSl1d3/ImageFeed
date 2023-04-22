//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 18.04.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

    weak var delegate: WebViewControllerDelegate?

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)
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
        webView.load(request)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    @IBAction func didTapBack(_ sender: Any?) {
        delegate?.webViewControllerDidCancel(self)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewController {
    func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
               return codeItem.value
           }

        return nil
    }

    func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}
