//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 18.04.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    var viewOutput: WebViewOutput?

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    private var webViewObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.accessibilityIdentifier = "UnsplashWebView"

        webView.navigationDelegate = self
        setupObservers()
        viewOutput?.viewDidLoad()
    }

    @IBAction func didTapBack(_ sender: Any?) {
        viewOutput?.didTapCloseButton()
    }
}

extension WebViewController: WebViewInput {
    func load(request: URLRequest) {
        webView.load(request)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.setProgress(newValue, animated: true)
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            viewOutput?.didAuthenticate(with: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewController {
    func setupObservers() {
        webViewObserver = webView.observe(
            \.estimatedProgress,
             options: .new
        ) { [weak self] _, change in
            guard let self else { return }
            viewOutput?.didUpdateProgressValue(change.newValue ?? 0.0)
        }
    }

    func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return viewOutput?.code(from: url)
        }

        return nil
    }
}
