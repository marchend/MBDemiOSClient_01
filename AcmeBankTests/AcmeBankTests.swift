import XCTest
@testable import AcmeBank

final class AcmeBankTests: XCTestCase {
    /// Bootstrap proof-of-life: test target compiles + links against the
    /// app module. Real behaviour tests belong in feature stories.
    /// Do NOT wrap ContentView in a UIHostingController and walk for
    /// UILabels — SwiftUI Text does not render as UILabel and the test
    /// will fail.
    func test_contentView_initializes() {
        _ = ContentView()
    }
}
