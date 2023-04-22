//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 18.04.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    let showWebViewSegueIdentifier = "ShowWebView"

    let oauth2Service = OAuth2Service()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier,
           let webViewController = segue.destination as? WebViewController {
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchAuthToken(with: code) { token in
            print("user token is: \(token)")
        }
        vc.dismiss(animated: true)
    }

    func webViewControllerDidCancel(_ vc: WebViewController) {
        vc.dismiss(animated: true)
    }
}
