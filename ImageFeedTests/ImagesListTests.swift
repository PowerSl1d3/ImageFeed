//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Олег Аксененко on 21.05.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListViewOutput, ImageListCellDelegate {
    var viewDidLoadCalled: Bool = false

    var photos: ImageFeed.Photos = []

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func prepareShowSingleImage(for segue: UIStoryboardSegue, sender: Any?) {

    }

    func tableViewWillDisplayCell(at indexPath: IndexPath) {

    }

    func didSelectRow(at indexPath: IndexPath) {

    }

    func didTapLikeButton(cell: ImageFeed.ImageListCell, cellModel: ImageFeed.Photo?) {

    }
}

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewInput {
    var updateTableViewAnimatedCalled: Bool = false
    var viewOutput: ImagesListViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewOutput.viewDidLoad()
    }

    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
}

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var fetchPhotosNextPageDidCalled: Bool = false

    var photos: ImageFeed.Photos = [
        Photo(
            id: "id",
            size: .zero,
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "https://www.google.com",
            largeImageURL: "https://www.google.com",
            isLiked: false
        )
    ]

    func fetchPhotosNextPage() {
        fetchPhotosNextPageDidCalled = true
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {

    }


}

final class ImagesListTests: XCTestCase {
    // MARK: Assembler

    func testImagesListAssembledDidAssembleModule() throws {
        // Given
        // When
        let viewController = ImagesListAssembler.assemble()

        // Then
        let imagesListViewController = viewController as? ImagesListViewController
        XCTAssertNotNil(imagesListViewController)

        let presenter = imagesListViewController?.viewOutput as? ImagesListPresenter
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(presenter?.view)
    }

    // MARK: ViewController

    func testImagesListViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ImagesListAssembler.assemble() as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.viewOutput = presenter

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    // MARK: Presenter

    func testImagesListPresenterCallsFetchPhotosNextPage() {
        // Given
        let viewController = ImagesListAssembler.assemble() as! ImagesListViewController
        let presenter = viewController.viewOutput as! ImagesListPresenter
        let imagesListService = ImagesListServiceSpy()
        presenter.imagesListService = imagesListService

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(imagesListService.fetchPhotosNextPageDidCalled)
    }

    func testImagesListPresenterCallsUpdateTableViewAnimated() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        let imagesListService = ImagesListServiceSpy()
        viewController.viewOutput = presenter
        presenter.view = viewController
        presenter.imagesListService = imagesListService

        // When
        _ = viewController.view

        NotificationCenter.default.post(
            name: ImagesListService.DidChangeNotification,
            object: nil
        )

        // Then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
}
