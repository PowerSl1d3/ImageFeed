//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 05.03.2023.
//

import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ImageListCell.self)

    var cellModel: Photo?
    weak var delegate: ImageListCellDelegate?

    var isLikeButtonUserInteractionEnabled: Bool {
        get {
            likeButton.isUserInteractionEnabled
        }
        set {
            likeButton.isUserInteractionEnabled = newValue
        }
    }

    private let photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16

        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypRegularFont(ofSize: 13)
        label.textColor = .ypWhite

        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)

        contentView.backgroundColor = .ypBlack

        contentView.addSubview(photoImage)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        photoImage.kf.cancelDownloadTask()
    }

    func setIsLiked(_ isLiked: Bool) {
        likeButton.setImage(UIImage(resource: isLiked ? .likeHeartActive : .likeHeartDisabled), for: .normal)
        likeButton.accessibilityIdentifier = isLiked ? "DislikeButton" : "LikeButton"
    }

    func configure(
        for cellModel: Photo,
        dateFormatter: DateFormatter,
        setImageCompletion: (() -> Void)? = nil
    ) {
        guard let imageUrl = URL(
            string: cellModel.thumbImageURL
        ) else {
            return
        }

        self.cellModel = cellModel
        photoImage.kf.indicatorType = .activity
        photoImage.kf.setImage(with: imageUrl, placeholder: UIImage(resource: .photoStub)) { _ in
            setImageCompletion?()
        }

        if let createdAt = cellModel.createdAt {
            dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            dateLabel.text = nil
        }

        setIsLiked(cellModel.isLiked)
    }
}

private extension ImageListCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            dateLabel.leadingAnchor.constraint(equalTo: photoImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: photoImage.trailingAnchor, constant: -8),

            likeButton.topAnchor.constraint(equalTo: photoImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: photoImage.trailingAnchor)
        ])
    }

    @objc func didTapLikeButton() {
        delegate?.didTapLikeButton(cell: self, cellModel: cellModel)
    }
}
