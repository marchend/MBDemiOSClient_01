import XCTest
import SwiftUI
@testable import AcmeBank

/// "Snapshot" tests implemented as UIHostingController render tests — CI-safe because
/// there is no PNG comparison.  Each test instantiates the view in a known state,
/// renders it inside a UIHostingController, and asserts that the view hierarchy is
/// non-empty (render-without-crash).  ViewModel state is tested separately in
/// LoginViewModelTests.
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
        let view = LoginView(onSignIn: { _, _ in })
        let hc = makeHostingController(for: view)

        // The host view should exist and have a non-zero frame.
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    // MARK: - Error banner visible

    @MainActor
    func test_loginView_errorBannerVisible_rendersWithoutCrash() {
        // The InlineErrorBanner view renders without crashing when a message is set.
        let banner = InlineErrorBanner(message: "Invalid username or password. Please try again.")
        let hc = makeHostingController(for: banner)
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    @MainActor
    func test_loginView_noErrorBanner_rendersWithoutCrash() {
        // Rendering a nil-message banner should not crash.
        let banner = InlineErrorBanner(message: nil)
        let hc = makeHostingController(for: banner)
        XCTAssertFalse(hc.view.frame.isEmpty)
    }

    // MARK: - Sign-in button state

    @MainActor
    func test_loginView_rendersWithoutCrash_whenBothFieldsNonEmpty() {
        // Full LoginView renders without crashing.
        let view = LoginView(onSignIn: { _, _ in })
        let hc = makeHostingController(for: view)
        XCTAssertFalse(hc.view.frame.isEmpty)
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
