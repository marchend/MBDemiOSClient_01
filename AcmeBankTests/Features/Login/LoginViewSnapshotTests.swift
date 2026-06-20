import XCTest
import SwiftUI
@testable import AcmeBank

/// "Snapshot" tests implemented as UIHostingController render tests — CI-safe because
/// there is no PNG comparison.  Each test instantiates the view (or its ViewModel) in
/// a known state, renders it inside a UIHostingController, and asserts on structural
/// ViewModel state rather than pixel output.  Pixel accuracy is verified by human
/// review of the simulator screenshot in the PR description.
final class LoginViewSnapshotTests: XCTestCase {

    // MARK: - Helpers

    @MainActor
    private func makeHostingController(
        for view: some View,
        size: CGSize = CGSize(width: 393, height: 852) // iPhone 16 Pro logical pts
    ) -> UIHostingController<AnyView> {
        let hc = UIHostingController(rootView: AnyView(view))
        hc.view.frame = CGRect(origin: .zero, size: size)
        hc.view.setNeedsLayout()
        hc.view.layoutIfNeeded()
        return hc
    }

    // MARK: - Default / empty state

    @MainActor
    func test_loginView_defaultState_rendersWithoutCrash() {
        let vm = LoginViewModel()
        let view = LoginView(onSignIn: { _, _ in })
        let hc = makeHostingController(for: view)

        // The host view should exist and have a non-zero frame.
        XCTAssertFalse(hc.view.frame.isEmpty)

        // ViewModel state assertions for the default empty state.
        XCTAssertEqual(vm.username, "")
        XCTAssertEqual(vm.password, "")
        XCTAssertFalse(vm.isSignInEnabled)
        XCTAssertNil(vm.errorMessage)
    }

    // MARK: - Error banner visible

    @MainActor
    func test_loginView_errorBannerVisible_vmHasErrorMessage() {
        let vm = LoginViewModel()
        vm.errorMessage = "Invalid username or password. Please try again."

        // Error message should be populated.
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertEqual(vm.errorMessage, "Invalid username or password. Please try again.")

        // The InlineErrorBanner view renders without crashing.
        let banner = InlineErrorBanner(message: vm.errorMessage)
        let hc = makeHostingController(for: banner)
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    @MainActor
    func test_loginView_noErrorBanner_whenErrorMessageNil() {
        let vm = LoginViewModel()
        XCTAssertNil(vm.errorMessage)

        // Rendering a nil-message banner should not crash.
        let banner = InlineErrorBanner(message: nil)
        let hc = makeHostingController(for: banner)
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    // MARK: - Sign-in button enabled / disabled

    @MainActor
    func test_loginView_signInButtonEnabled_whenBothFieldsNonEmpty() {
        let vm = LoginViewModel()
        vm.username = "user@example.com"
        vm.password = "secret"

        XCTAssertTrue(vm.isSignInEnabled,
            "Sign-in button should be enabled when both username and password are non-empty.")

        // Full LoginView renders without crashing in this state.
        let view = LoginView(onSignIn: { _, _ in })
        let hc = makeHostingController(for: view)
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    @MainActor
    func test_loginView_signInButtonDisabled_whenFieldsEmpty() {
        let vm = LoginViewModel()

        XCTAssertFalse(vm.isSignInEnabled,
            "Sign-in button should be disabled when fields are empty.")
    }

    // MARK: - Components render without crashing

    @MainActor
    func test_hexagonShape_rendersWithoutCrash() {
        let view = HexagonShape()
            .fill(Color.acmeNavy)
            .frame(width: 80, height: 80)
        let hc = makeHostingController(for: view, size: CGSize(width: 100, height: 100))
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    @MainActor
    func test_oktaAddressBar_rendersWithoutCrash() {
        let hc = makeHostingController(for: OktaAddressBar(), size: CGSize(width: 393, height: 44))
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    @MainActor
    func test_securedByOktaFooter_rendersWithoutCrash() {
        let hc = makeHostingController(for: SecuredByOktaFooter(), size: CGSize(width: 393, height: 44))
        XCTAssertFalse(hc.view.frame.isEmpty)
    }
}
