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
        formatter.dateStyle = .long
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
            let image = (tableView.cellForRow(at: indexPath) as? ImageListCell)?.photoImage.image
            viewController.image = image
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

        let evenIndexPath = indexPath.row % 2 == 0
        let likeButtonImage = UIImage(named: evenIndexPath ? "LikeHeartActive" : "LikeHeartDisabled")

        guard let likeButtonImage else { return }

        cell.photoImage.kf.indicatorType = .activity
        cell.photoImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "PhotoStub")) { [weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        cell.dateLabel.text = dateFormatter.string(from: currentPhoto.createdAt ?? Date())
        cell.likeButton.setImage(likeButtonImage, for: .normal)
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

