//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 18.04.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    weak var delegate: WebViewControllerDelegate?

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    private var webViewObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        webViewObserver = webView.observe(
            \.estimatedProgress,
             options: .new
        ) { [weak self] _, change in
            guard let self else { return }
            self.updateProgress()
        }

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
        webView.load(request)
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
