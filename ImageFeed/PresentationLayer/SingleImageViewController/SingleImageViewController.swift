//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Олег Аксененко on 07.03.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var imageUrl: String! {
        didSet {
            guard isViewLoaded else { return }
            updateImageView()
        }
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    private var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertPresenter.viewController = self
        view.backgroundColor = UIColor(named: "YP Black")
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        updateImageView()
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true)
    }

    @IBAction func didTapShareButton() {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(activityController, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

private extension SingleImageViewController {
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    func updateImageView() {
        guard let imageUrl = URL(string: imageUrl) else { return }

        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }

            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }

    func showError() {
        var alertModel = AlertModel(
            title: "Что-то пошло не так:(",
            message: "Не удалось загрузить изображение",
            successfulButtonText: "Попробовать ещё раз"
        )

        alertModel.successfulCompletion = {
            self.updateImageView()
        }

        alertPresenter.show(alertModel: alertModel)
    }
}
