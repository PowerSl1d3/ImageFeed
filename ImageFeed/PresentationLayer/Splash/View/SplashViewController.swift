//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 22.04.2023.
//

import UIKit
import Swinject

final class SplashViewController: UIViewController {

    var viewOutput: SplashViewOutput?

    private let splashLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .practicumLogo))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(splashLogo)

        setupViews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewOutput?.viewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension SplashViewController: SplashViewInput {
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
    }

    func hideProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
}

private extension SplashViewController {
    func setupViews() {
        view.backgroundColor = .ypBlack
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            splashLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
