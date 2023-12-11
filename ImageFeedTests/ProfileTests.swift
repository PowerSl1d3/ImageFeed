//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Олег Аксененко on 20.05.2023.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterSpy: ProfileViewOutput {
    var viewDidLoadCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapProfileExitButton() {

    }
}

final class ProfileViewControllerSpy: UIViewController, ProfileViewInput {
    var viewOutput: ProfileViewOutput!

    var updateProfileDetailsCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var numberOfCallsUpdateAvatar = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        viewOutput.viewDidLoad()
    }

    func updateProfileDetails(profile: ImageFeed.Profile) {
        updateProfileDetailsCalled = true
    }

    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
        numberOfCallsUpdateAvatar += 1
    }
}

final class ProfileServiceStub: ProfileServiceProtocol {
    var profile: ImageFeed.Profile? {
        Profile(
            profileResult: ProfileResult(
                username: "PowerSl1d3",
                firstName: "firstName",
                lastName: "lastName",
                bio: "bio"
            )
        )
    }

    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {

    }
}

final class ProfileImageServiceProtocolStub: ProfileImageServiceProtocol {
    var avatarURL: String? { "https://www.google.com" }

    func fetchProfileImage(_ username: String, completion: @escaping (Result<String, Error>) -> Void) {

    }
}

final class ProfileRouterSpy: ProfileRouterInput {
    var showProfileExitAlertCalled: Bool = false

    func switchToSplashController() {

    }

    func showProfileExitAlert(successfullCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) {
        showProfileExitAlertCalled = true
    }
}

final class ProfileTests: XCTestCase {
    // MARK: Assembler

    func testProfileAssembledDidAssembleModule() throws {
        // Given
        // When
        let viewController = ProfileAssembly.assemble()

        // Then
        let profileViewController = viewController as? ProfileViewController
        XCTAssertNotNil(profileViewController)

        let presenter = profileViewController?.viewOutput as? ProfilePresenter
        XCTAssertNotNil(presenter)

        let router = presenter?.router as? ProfileRouter
        XCTAssertNotNil(router)

        let alertPresenter = router?.alertPresenter
        XCTAssertNotNil(alertPresenter?.viewController as? ProfileViewController)

        XCTAssertNotNil(profileViewController?.viewOutput)
        XCTAssertNotNil(presenter?.view)
        XCTAssertNotNil(presenter?.router)
        XCTAssertNotNil(router?.view)
        XCTAssertNotNil(router?.alertPresenter)
    }

    // MARK: - ViewController

    func testViewControllerCallsViewDidLoad() throws {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.viewOutput = presenter

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    // MARK: - Presenter

    func testPresenterCallsUpdateProfileDetails() throws {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.viewOutput = presenter
        presenter.view = viewController

        presenter.profileService = ProfileServiceStub()

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }

    func testPresenterCallsUpdateAvatar() throws {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.viewOutput = presenter
        presenter.view = viewController

        presenter.profileService = ProfileServiceStub()
        presenter.profileImageService = ProfileImageServiceProtocolStub()

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }

    func testPresentFetchApdateAvatarNotification() throws {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.viewOutput = presenter
        presenter.view = viewController

        presenter.profileService = ProfileServiceStub()
        presenter.profileImageService = ProfileImageServiceProtocolStub()

        // When
        _ = viewController.view
        NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: nil)

        // Then
        XCTAssertEqual(viewController.numberOfCallsUpdateAvatar, 2)
    }

    // MARK: - Router

    func testRouterShowProfileExitAlert() {
        // Given
        let presenter = ProfilePresenter()
        let router = ProfileRouterSpy()
        presenter.router = router

        // When
        presenter.didTapProfileExitButton()

        // Then
        XCTAssertTrue(router.showProfileExitAlertCalled)
    }
}
