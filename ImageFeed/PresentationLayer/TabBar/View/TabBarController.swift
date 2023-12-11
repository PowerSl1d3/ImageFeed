//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 09.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    var imagesListViewController: UIViewController!
    var profileViewController: UIViewController!

    init() {
        super.init(nibName: nil, bundle: nil)
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

    // Проставляем вью контроллеры тут, поскольку на момент инициализации таб бара вызывается `viewDidLoad`
    // в котором они ещё не проинициализированы
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewControllers = [imagesListViewController, profileViewController]
    }
}
