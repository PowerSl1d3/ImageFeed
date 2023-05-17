//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 18.04.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"

    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier,
           let webViewController = segue.destination as? WebViewController {
            let authHelper = AuthHelper()
            let presenter = WebViewPresenter(authHelper: authHelper)
            webViewController.viewOutput = presenter
            presenter.view = webViewController
            presenter.moduleOutput = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewModuleOutput {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
}
