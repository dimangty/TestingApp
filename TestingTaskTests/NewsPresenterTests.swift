import XCTest
import SwiftyMocky
@testable import TestingTask

final class NewsPresenterTests: XCTestCase {
    private var presenter: NewsPresenter!

    override func setUp() {
        super.setUp()
        presenter = makePresenter()
    }

    func test_article_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.article()
        XCTFail("TODO: implement NewsPresenter.article test")
    }

    func test_didAddToFavorites_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.didAddToFavorites()
        XCTFail("TODO: implement NewsPresenter.didAddToFavorites test")
    }

    func test_didRemoveFromFavorites_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.didRemoveFromFavorites()
        XCTFail("TODO: implement NewsPresenter.didRemoveFromFavorites test")
    }

    func test_didSelectRow_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.didSelectRow()
        XCTFail("TODO: implement NewsPresenter.didSelectRow test")
    }

    func test_didTapFavorite_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.didTapFavorite()
        XCTFail("TODO: implement NewsPresenter.didTapFavorite test")
    }

    func test_didUpdateSearch_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.didUpdateSearch()
        XCTFail("TODO: implement NewsPresenter.didUpdateSearch test")
    }

    func test_numberOfRows_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.numberOfRows()
        XCTFail("TODO: implement NewsPresenter.numberOfRows test")
    }

    func test_viewLoaded_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.viewLoaded()
        XCTFail("TODO: implement NewsPresenter.viewLoaded test")
    }

    func test_viewWillAppear_TODO() {
        // TODO: Implement behavior checks for NewsPresenter.viewWillAppear()
        XCTFail("TODO: implement NewsPresenter.viewWillAppear test")
    }

}

private extension NewsPresenterTests {
    func makePresenter() -> NewsPresenter {
        fatalError("TODO: initialize NewsPresenter with mocks and dependencies")
    }
}
