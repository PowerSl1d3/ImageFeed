//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 05.03.2023.
//

import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImage.kf.cancelDownloadTask()
    }
}
