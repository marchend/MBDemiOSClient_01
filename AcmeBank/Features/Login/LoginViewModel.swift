import Foundation
import Combine

/// ViewModel for the Login screen.
///
/// Holds all mutable state the login UI needs:
/// - `username` / `password` — bound to the text fields
/// - `isPasswordVisible` — toggled by the eye button
/// - `errorMessage` — set externally (e.g. from an auth adapter) to surface inline errors
///
/// The `onSignIn` closure is injected at the call site; this ViewModel
/// never imports any auth SDK and knows nothing about Okta.
final class LoginViewModel: ObservableObject {
    // MARK: - Published state

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var errorMessage: String?

    // MARK: - Computed state

    /// `true` only when both `username` and `password` are non-empty.
    var isSignInEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }

    // MARK: - Dependencies

    /// Called with `(username, password)` when the user taps Sign In.
    /// Injected at the composition root; defaults to a no-op so previews
    /// and unit tests can omit it.
    var onSignIn: (String, String) -> Void

    // MARK: - Init

    init(onSignIn: @escaping (String, String) -> Void = { _, _ in }) {
        self.onSignIn = onSignIn
    }

    // MARK: - Actions

    /// Forwards the current credentials to the injected `onSignIn` closure.
    func signIn() {
        guard isSignInEnabled else { return }
        onSignIn(username, password)
    }
}
