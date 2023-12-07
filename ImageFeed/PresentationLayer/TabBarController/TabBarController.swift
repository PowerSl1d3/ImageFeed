//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 09.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)

        let imagesListViewController = ImagesListAssembler.assemble()
        let profileViewController = ProfileAssembler.assemble()

        viewControllers = [imagesListViewController, profileViewController]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ypBlack

        tabBar.standardAppearance = appearance
    }
}
