//
//  AlertPresenterService.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 02.05.2023.
//

import Foundation
import UIKit

protocol AlertPresenterServiceProtocol {
    var viewController: UIViewController? { get set }

    func show(alertModel: AlertModel)
}

struct AlertPresenterService: AlertPresenterServiceProtocol {
    weak var viewController: UIViewController?

    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )

        if alertModel.successfulCompletion != nil {
            let action = UIAlertAction(title: alertModel.successfulButtonText, style: .default) { _ in
                alertModel.successfulCompletion?()
            }
            alert.addAction(action)
        }

        if alertModel.cancelCompletion != nil {
            let action = UIAlertAction(title: alertModel.cancelButtonText, style: .default) { _ in
                alertModel.cancelCompletion?()
            }
            alert.addAction(action)
        }

        viewController?.present(alert, animated: true, completion: nil)
    }
}
