//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by Олег Аксененко on 18.05.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewPresenterSpy: WebViewOutput {
    var viewDidLoadCalled: Bool = false
    var view: WebViewInput?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {

    }

    func code(from url: URL) -> String? {
        return nil
    }

    func webViewViewController(_ vc: ImageFeed.WebViewController, didAuthenticateWithCode code: String) {

    }

    func webViewControllerDidCancel(_ vc: ImageFeed.WebViewController) {

    }
}

final class WebViewControllerSpy: WebViewInput {
    var loadRequestCalled: Bool = false
    var viewOutput: WebViewOutput?

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let presenter = WebViewPresenterSpy()
        viewController.viewOutput = presenter
        presenter.view = viewController

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsLoadRequest() {
        // Given
        let viewController = WebViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.viewOutput = presenter
        presenter.view = viewController

        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(viewController.loadRequestCalled)
    }

    func testProgressVisibleWhenLessThenOne() {
        // Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        // Then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressHiddenWhenOne() {
        // Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1

        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        // Then
        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() {
        // Given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        // When
        let url = try! authHelper.authURL()
        let urlString = url.absoluteString

        // Then
        XCTAssertTrue(urlString.contains(configuration.authURL.absoluteString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }

    func testCodeFromURL() {
        // Given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        let url = urlComponents.url!
        let authHelper = AuthHelper()

        // When
        let code = authHelper.code(from: url)

        // Then
        XCTAssertEqual(code, "test code")
    }
}
