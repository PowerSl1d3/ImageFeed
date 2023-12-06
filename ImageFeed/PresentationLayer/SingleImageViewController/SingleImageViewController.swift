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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.clipsToBounds = true
        button.layer.cornerRadius = 25

        return button
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "NavigationBarBackward"), for: .normal)
        button.tintColor = .ypBlack

        return button
    }()

    private var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)

        view.addSubview(scrollView)
        view.addSubview(shareButton)
        view.addSubview(backButton)
        scrollView.addSubview(imageView)

        alertPresenter.viewController = self
        view.backgroundColor = .ypBlack
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        updateImageView()
        setupConstraints()
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }

    @objc func didTapShareButton() {
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
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),

            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),

            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

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
