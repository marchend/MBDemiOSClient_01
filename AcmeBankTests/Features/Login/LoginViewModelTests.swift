import XCTest
@testable import AcmeBank

final class LoginViewModelTests: XCTestCase {

    // MARK: - isSignInEnabled

    func test_isSignInEnabled_false_whenBothFieldsEmpty() {
        let vm = LoginViewModel()
        XCTAssertFalse(vm.isSignInEnabled)
    }

    func test_isSignInEnabled_false_whenUsernameEmptyPasswordNonEmpty() {
        let vm = LoginViewModel()
        vm.password = "secret"
        XCTAssertFalse(vm.isSignInEnabled)
    }

    func test_isSignInEnabled_false_whenPasswordEmptyUsernameNonEmpty() {
        let vm = LoginViewModel()
        vm.username = "user@example.com"
        XCTAssertFalse(vm.isSignInEnabled)
    }

    func test_isSignInEnabled_true_whenBothFieldsNonEmpty() {
        let vm = LoginViewModel()
        vm.username = "user@example.com"
        vm.password = "secret"
        XCTAssertTrue(vm.isSignInEnabled)
    }

    // MARK: - signIn()

    func test_signIn_invokesClosureWithCorrectCredentials() {
        var capturedUsername: String?
        var capturedPassword: String?

        let vm = LoginViewModel { username, password in
            capturedUsername = username
            capturedPassword = password
        }

        vm.username = "alice@example.com"
        vm.password = "p@ssw0rd!"
        vm.signIn()

        XCTAssertEqual(capturedUsername, "alice@example.com")
        XCTAssertEqual(capturedPassword, "p@ssw0rd!")
    }

    func test_signIn_doesNotInvokeClosure_whenFieldsEmpty() {
        var callCount = 0
        let vm = LoginViewModel { _, _ in callCount += 1 }

        // Both empty — guard inside signIn should prevent the call
        vm.signIn()

        XCTAssertEqual(callCount, 0)
    }

    func test_signIn_doesNotInvokeClosure_whenOnlyUsernameSet() {
        var callCount = 0
        let vm = LoginViewModel { _, _ in callCount += 1 }
        vm.username = "alice@example.com"

        vm.signIn()

        XCTAssertEqual(callCount, 0)
    }

    // MARK: - Default state

    func test_errorMessage_isNilByDefault() {
        let vm = LoginViewModel()
        XCTAssertNil(vm.errorMessage)
    }

    func test_isPasswordVisible_falseByDefault() {
        let vm = LoginViewModel()
        XCTAssertFalse(vm.isPasswordVisible)
    }

    func test_username_emptyByDefault() {
        let vm = LoginViewModel()
        XCTAssertEqual(vm.username, "")
    }

    func test_password_emptyByDefault() {
        let vm = LoginViewModel()
        XCTAssertEqual(vm.password, "")
    }

    // MARK: - Published state mutations

    func test_errorMessage_canBeSet() {
        let vm = LoginViewModel()
        vm.errorMessage = "Invalid credentials"
        XCTAssertEqual(vm.errorMessage, "Invalid credentials")
    }

    func test_isPasswordVisible_canBeToggled() {
        let vm = LoginViewModel()
        XCTAssertFalse(vm.isPasswordVisible)
        vm.isPasswordVisible = true
        XCTAssertTrue(vm.isPasswordVisible)
    }
}
