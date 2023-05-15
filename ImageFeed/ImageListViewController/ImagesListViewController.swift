//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 12.02.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"

    @IBOutlet private weak var tableView: UITableView!

    private let imagesListService = ImagesListService()
    private var photos: [Photo] = []

    private var imagesListServiceObserver: NSObjectProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                updateTableViewAnimated()
            }

        imagesListService.fetchPhotosNextPage()
        tableView.contentInset = UIEdgeInsets(top: 12, left: .zero, bottom: 12, right: .zero)
        tableView.estimatedRowHeight = 0
    }

    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            let imageUrl = photos[indexPath.row].largeImageURL
            viewController.imageUrl = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard indexPath.row + 1 == imagesListService.photos.count else { return }
        imagesListService.fetchPhotosNextPage()
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        photos.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }

        configure(cell: imageListCell, for: indexPath)

        return imageListCell
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func didTapLikeButton(cell: ImageListCell, cellModel: Photo?) {
        guard let cellModel,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        cell.likeButton.isUserInteractionEnabled = false

        imagesListService.changeLike(
            photoId: cellModel.id,
            isLike: !cellModel.isLiked
        ) { [weak self, weak cell] result in
            defer { cell?.likeButton.isUserInteractionEnabled = true }

            guard let self, let cell, case .success = result else { return }

            let photo = self.photos[indexPath.row]
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: !photo.isLiked
            )
            self.photos[indexPath.row] = newPhoto
            cell.setIsLiked(newPhoto.isLiked)
        }
    }
}

private extension ImagesListViewController {
    func configure(
        cell: ImageListCell,
        for indexPath: IndexPath
    ) {
        let currentPhoto = photos[indexPath.row]

        guard let imageUrl = URL(
            string: currentPhoto.thumbImageURL
        ) else {
            return
        }

        cell.cellModel = currentPhoto
        cell.delegate = self
        cell.photoImage.kf.indicatorType = .activity
        cell.photoImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "PhotoStub")) { [weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        if let createdAt = currentPhoto.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel.text = nil
        }

        cell.setIsLiked(currentPhoto.isLiked)
    }

    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

