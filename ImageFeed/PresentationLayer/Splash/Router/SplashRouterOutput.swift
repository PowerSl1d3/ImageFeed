//
//  SplashRouterOutput.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 12.12.2023.
//

import UIKit

protocol SplashRouterOutput: AnyObject {
    func authViewControllerDidAuthenticate(with code: String, _ vc: UIViewController)
}
