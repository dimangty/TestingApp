import XCTest
import SnapshotTesting
@testable import TestingTask

final class ScreenSnapshotTests: XCTestCase {
    private static let isRecordingSnapshots = ProcessInfo.processInfo.environment["SNAPSHOT_RECORD"] == "1"

    override func setUp() {
        super.setUp()
        #if DEBUG
        Configurator.shared.setupForUnitTests()
        #else
        Configurator.shared.setup()
        #endif
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    func testLoginScreenSnapshot() throws {
        // Given
        // Build the full VIPER module so snapshot covers real production wiring.
        let module = try XCTUnwrap(LoginScreenRouter().createModule())

        // When
        // Render the screen inside a navigation stack with a deterministic frame.
        let hostController = hostForSnapshot(module)

        // Then
        // Compare rendered pixels with the checked-in baseline image.
        assertSnapshot(of: hostController.view,
                       as: .image,
                       named: "login_screen",
                       record: Self.isRecordingSnapshots)
    }

    func testSignUpScreenSnapshot() throws {
        // Given
        // Build the sign-up module in the same way users open it from the app flow.
        let module = try XCTUnwrap(SignUpScreenRouter().createModule())

        // When
        // Render layout after view lifecycle callbacks are completed.
        let hostController = hostForSnapshot(module)

        // Then
        // Validate the visual state against the reference snapshot.
        assertSnapshot(of: hostController.view,
                       as: .image,
                       named: "signup_screen",
                       record: Self.isRecordingSnapshots)
    }

    func testArticleScreenSnapshot() throws {
        // Given
        // Use a deterministic article payload to keep snapshot output stable.
        let articleTitle = "Snapshot Article"
        StorageService.shared.removeFromFavorites(title: articleTitle)
        let article = Article(author: "Snapshot Author",
                              title: articleTitle,
                              description: "Snapshot content",
                              url: nil,
                              urlToImage: nil,
                              publishedAt: Date(timeIntervalSince1970: 0))
        let model = ArticleViewModel(article: article, storage: StorageService.shared)
        let module = try XCTUnwrap(ArticleRouter(article: model).createModule())

        // When
        // Render the article module in a controlled host container.
        let hostController = hostForSnapshot(module)

        // Then
        // Ensure the article screen appearance stays unchanged.
        assertSnapshot(of: hostController.view,
                       as: .image,
                       named: "article_screen",
                       record: Self.isRecordingSnapshots)
    }

    private func hostForSnapshot(_ rootViewController: UIViewController) -> UINavigationController {
        let hostController = UINavigationController(rootViewController: rootViewController)
        hostController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        hostController.loadViewIfNeeded()
        rootViewController.loadViewIfNeeded()
        hostController.view.layoutIfNeeded()

        // Let asynchronous layout and presenter callbacks finish before capture.
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
        hostController.view.layoutIfNeeded()

        return hostController
    }
}
