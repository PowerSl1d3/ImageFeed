//
//  SplashViewControllerAssembly.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 09.12.2023.
//

import UIKit
import Swinject

final class SplashViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SplashViewController.self) { resolver in
            let viewController = SplashViewController()
            viewController.resolver = resolver

            return viewController
        }
    }
}
