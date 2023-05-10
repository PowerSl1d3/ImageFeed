//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 12.02.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"

    @IBOutlet private weak var tableView: UITableView!

    private let imagesListService = ImagesListService()
    private let photosName = { (0..<20).map(String.init) }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListService.fetchPhotosNextPage()

        tableView.contentInset = UIEdgeInsets(top: 12, left: .zero, bottom: 12, right: .zero)
    }

    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            let image = UIImage(named: photosName[indexPath.row])
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
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
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
        photosName.count
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
        let image = UIImage(named: photosName[indexPath.row])
        guard let image else { return }

        let evenIndexPath = indexPath.row % 2 == 0
        let likeButtonImage = UIImage(named: evenIndexPath ? "LikeHeartActive" : "LikeHeartDisabled")

        guard let likeButtonImage else { return }

        cell.photoImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setImage(likeButtonImage, for: .normal)
    }
}

