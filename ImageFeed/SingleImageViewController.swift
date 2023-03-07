//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 07.03.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "YP Black")
        imageView.image = image
    }
}
