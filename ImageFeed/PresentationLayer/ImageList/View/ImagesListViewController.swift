//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 12.02.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    var viewOutput: (ImagesListViewOutput & ImageListCellDelegate)!

    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"

    @IBOutlet private weak var tableView: UITableView!

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 12, left: .zero, bottom: 12, right: .zero)
        tableView.estimatedRowHeight = 0
        viewOutput.viewDidLoad()
    }

    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
           viewOutput.prepareShowSingleImage(for: segue, sender: sender)
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
        let imageSize = viewOutput.photos[indexPath.row].size
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
        viewOutput.tableViewWillDisplayCell(at: indexPath)
    }
}

extension ImagesListViewController: ImagesListViewInput {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewOutput.photos.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }

        let photo = viewOutput.photos[indexPath.row]
        imageListCell.configure(
            for: photo,
            dateFormatter: dateFormatter
        ) { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        imageListCell.delegate = viewOutput

        return imageListCell
    }
}

