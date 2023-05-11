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

    var cellModel: Photo?
    weak var delegate: ImageListCellDelegate?

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImage.kf.cancelDownloadTask()
    }

    func setIsLiked(_ isLiked: Bool) {
        guard let likeButtonImage = UIImage(
            named: isLiked ? "LikeHeartActive" : "LikeHeartDisabled"
        ) else {
            return
        }
        likeButton.setImage(likeButtonImage, for: .normal)
    }
}

private extension ImageListCell {
    @IBAction func didTapLikeButton() {
        delegate?.didTapLikeButton(cell: self, cellModel: cellModel)
    }
}
