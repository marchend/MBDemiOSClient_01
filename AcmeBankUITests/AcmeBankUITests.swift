import XCTest

/// Bootstrap UI test stub.
/// Critical-flow UI tests (login, transfer, sign-out) are added in
/// their respective feature stories. This file exists to satisfy the
/// AcmeBankUITests bundle.ui-testing target requirement — an empty
/// xctest bundle has no executable and fails `xcodebuild test`.
final class AcmeBankUITests: XCTestCase {
    /// Proof-of-life: app launches without crashing.
    func test_appLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    }
}
