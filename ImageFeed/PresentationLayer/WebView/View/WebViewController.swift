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

    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.accessibilityIdentifier = "UnsplashWebView"

        return webView
    }()

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false

        return progressView
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "NavigationBarBackward"), for: .normal)
        button.tintColor = .ypBlack

        return button
    }()

    private var webViewObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(backButton)

        webView.navigationDelegate = self
        setupObservers()
        setupConstraints()

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

private extension WebViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),

            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor)
        ])
    }
}
