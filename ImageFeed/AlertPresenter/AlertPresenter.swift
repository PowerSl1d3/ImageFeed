//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 02.05.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func show(alertModel: AlertModel, presentingViewController: UIViewController?)
}

struct AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?

    func show(alertModel: AlertModel, presentingViewController: UIViewController?) {
        let presentingViewController = presentingViewController ?? delegate

        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion?()
        }

        alert.addAction(action)

        presentingViewController?.present(alert, animated: true, completion: nil)
    }
}
