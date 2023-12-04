//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 18.04.2023.
//

import UIKit

final class AuthViewController: UIViewController {

    weak var delegate: AuthViewControllerDelegate?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "UnsplashLogo")

        return imageView
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        let attributedTitle = NSAttributedString(
            string: "Войти",
            attributes: [
                .font: UIFont.ypBoldFont(ofSize: 17),
                .foregroundColor: UIColor.ypBlack as Any
            ]
        )

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)

        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        view.addSubview(loginButton)

        setupConstraints()
    }
}

extension AuthViewController: WebViewModuleOutput {
    func didAuthenticate(with code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func didTapCloseButton() {
        dismiss(animated: true)
    }
}

private extension AuthViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),

            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc func didTapLoginButton() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let webViewController = WebViewController()

        webViewController.viewOutput = presenter
        presenter.view = webViewController
        presenter.moduleOutput = self

        webViewController.modalPresentationStyle = .fullScreen
        present(webViewController, animated: true)
    }
}
