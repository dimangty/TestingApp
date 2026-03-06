//
//  LoginScreenSnapshotTests.swift
//  TestingTaskTests
//
//  Snapshot tests for LoginScreen UI states
//  Testing UI appearance and layout with SnapshotTesting
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - Initial state (empty phone, disabled button)
//  - Valid phone entered state (enabled button)
//  - Invalid phone entered state (disabled button)
//  - Different iPhone screen sizes
//
//  Note: Snapshot tests are used only for complex UI states
//  No dynamic dates, animations, or random IDs per guidelines
//

import Testing
import SnapshotTesting
import UIKit
@testable import TestingTask

@Suite("LoginScreen Snapshot Tests - UI States")
struct LoginScreenSnapshotTests {

    // MARK: - Test: Initial Empty State

    /// Tests the initial appearance of login screen with empty phone field
    /// Business rule: Confirm button should be visually disabled (alpha 0.5)
    @Test("Should match snapshot for initial empty state")
    func testInitialEmptyState() {
        // Given: A login screen in initial state
        let viewController = createLoginViewController()

        // When: View is loaded
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()

        // Then: Should match snapshot for initial state
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Valid Phone Entered State

    /// Tests the appearance with valid phone number entered
    /// Business rule: Confirm button should be enabled and fully opaque
    @Test("Should match snapshot with valid phone entered")
    func testValidPhoneEnteredState() {
        // Given: A login screen with valid phone number
        let viewController = createLoginViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()

        // When: Valid phone number is entered
        simulatePhoneInput(viewController, phone: "1234567890")
        viewController.updateConfirmButton(enabled: true)

        // Then: Should match snapshot with enabled button
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Invalid Short Phone State

    /// Tests the appearance with too short phone number
    /// Business rule: Confirm button should remain disabled
    @Test("Should match snapshot with short phone number")
    func testShortPhoneEnteredState() {
        // Given: A login screen with short phone number
        let viewController = createLoginViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()

        // When: Short phone number is entered
        simulatePhoneInput(viewController, phone: "12345")
        viewController.updateConfirmButton(enabled: false)

        // Then: Should match snapshot with disabled button
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Maximum Length Phone State

    /// Tests the appearance with maximum valid phone length (15 digits)
    /// Business rule: Should accept and display 15-digit phone number
    @Test("Should match snapshot with maximum length phone")
    func testMaximumLengthPhoneState() {
        // Given: A login screen with maximum length phone
        let viewController = createLoginViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()

        // When: 15-digit phone number is entered
        simulatePhoneInput(viewController, phone: "123456789012345")
        viewController.updateConfirmButton(enabled: true)

        // Then: Should match snapshot with all digits visible
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Different Device Sizes

    /// Tests layout on iPhone SE (small screen)
    /// Business rule: UI should adapt to smaller screens
    @Test("Should match snapshot on iPhone SE")
    func testLayoutOniPhoneSE() {
        // Given: A login screen for small device
        let viewController = createLoginViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()

        // When: View is displayed on iPhone SE
        // Then: Should match snapshot with proper layout
        assertSnapshot(of: viewController, as: .image(on: .iPhoneSe))
    }

    /// Tests layout on iPhone 13 Pro Max (large screen)
    /// Business rule: UI should adapt to larger screens
    @Test("Should match snapshot on iPhone 13 Pro Max")
    func testLayoutOniPhone13ProMax() {
        // Given: A login screen for large device
        let viewController = createLoginViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()

        // When: View is displayed on iPhone 13 Pro Max
        // Then: Should match snapshot with proper layout
        assertSnapshot(of: viewController, as: .image(on: .iPhone13ProMax))
    }

    // MARK: - Test: Dark Mode Appearance

    /// Tests appearance in dark mode
    /// Business rule: UI should properly support dark mode
    @Test("Should match snapshot in dark mode")
    func testDarkModeAppearance() {
        // Given: A login screen in dark mode
        let viewController = createLoginViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()
        viewController.overrideUserInterfaceStyle = .dark

        // When: View is displayed in dark mode
        // Then: Should match snapshot with dark theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Light Mode Appearance

    /// Tests appearance in light mode (explicit)
    /// Business rule: UI should properly support light mode
    @Test("Should match snapshot in light mode")
    func testLightModeAppearance() {
        // Given: A login screen in light mode
        let viewController = createLoginViewController()
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()
        viewController.overrideUserInterfaceStyle = .light

        // When: View is displayed in light mode
        // Then: Should match snapshot with light theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }
}

// MARK: - Helper Functions

/// Creates a LoginScreenViewController instance for testing
/// - Returns: Configured LoginScreenViewController
private func createLoginViewController() -> LoginScreenViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let viewController = storyboard.instantiateViewController(
        withIdentifier: "LoginScreenViewController"
    ) as? LoginScreenViewController else {
        fatalError("Failed to instantiate LoginScreenViewController")
    }

    // Create a minimal presenter to prevent crashes
    let mockPresenter = MockLoginPresenter()
    viewController.presenter = mockPresenter

    return viewController
}

/// Simulates phone number input in the text field
/// - Parameters:
///   - viewController: The login view controller
///   - phone: The phone number to simulate
private func simulatePhoneInput(_ viewController: LoginScreenViewController, phone: String) {
    // Access the text field through the view hierarchy
    let mirror = Mirror(reflecting: viewController)
    for child in mirror.children {
        if child.label == "phoneTextField", let textField = child.value as? UITextField {
            textField.text = phone
            textField.sendActions(for: .editingChanged)
        }
    }
}

// MARK: - Mock Presenter

/// Minimal mock presenter for snapshot testing
/// Prevents crashes by providing no-op implementations
private class MockLoginPresenter: LoginScreenViewOutput {
    func viewLoaded() {
        // No-op for snapshot testing
    }

    func phoneChanged(_ phone: String) {
        // No-op for snapshot testing
    }

    func confirmTapped() {
        // No-op for snapshot testing
    }

    func signUpTapped() {
        // No-op for snapshot testing
    }
}
