//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 02.05.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    var viewController: UIViewController? { get set }

    func show(alertModel: AlertModel)
}

struct AlertPresenter: AlertPresenterProtocol {
    weak var viewController: UIViewController?

    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion?()
        }

        alert.addAction(action)

        viewController?.present(alert, animated: true, completion: nil)
    }
}
