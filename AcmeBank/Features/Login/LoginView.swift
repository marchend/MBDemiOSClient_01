import SwiftUI

/// Root login screen view.
///
/// Layout (top-to-bottom):
/// 1. `OktaAddressBar` — static top strip
/// 2. Scrollable content: logo badge · title · subtitle · fields · error banner · Sign-in button
/// 3. `SecuredByOktaFooter` — pinned to the bottom
///
/// The `onSignIn` closure is forwarded to `LoginViewModel` and called when
/// the user taps the enabled Sign-in button.
struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(onSignIn: @escaping (String, String) -> Void = { _, _ in }) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(onSignIn: onSignIn))
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Top Okta address strip ──────────────────────────────────
            OktaAddressBar()

            // ── Scrollable content area ─────────────────────────────────
            ScrollView {
                VStack(spacing: 24) {
                    // Logo badge
                    logoBadge

                    // Title & subtitle
                    VStack(spacing: 8) {
                        Text("Sign in to AcmeBank")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.acmeText)
                            .multilineTextAlignment(.center)

                        Text("Enter your credentials to continue.")
                            .font(.subheadline)
                            .foregroundColor(.acmeSubtext)
                            .multilineTextAlignment(.center)
                    }

                    // Fields
                    VStack(spacing: 12) {
                        // Username field
                        TextField("Username or email", text: $viewModel.username)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                            )
                            .accessibilityLabel("Username or email")

                        // Password field
                        PasswordFieldView(
                            placeholder: "Password",
                            text: $viewModel.password,
                            isVisible: $viewModel.isPasswordVisible
                        )
                    }

                    // Inline error banner (hidden / zero-height when nil)
                    InlineErrorBanner(message: viewModel.errorMessage)

                    // Sign-in button
                    Button {
                        viewModel.signIn()
                    } label: {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.acmeNavy)
                            .cornerRadius(8)
                            .opacity(viewModel.isSignInEnabled ? 1 : 0.4)
                    }
                    .disabled(!viewModel.isSignInEnabled)
                    .accessibilityLabel("Sign In")
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }

            Spacer(minLength: 0)

            // ── Bottom footer ───────────────────────────────────────────
            SecuredByOktaFooter()
        }
        .background(Color.acmeBackground.ignoresSafeArea())
    }

    // MARK: - Sub-views

    private var logoBadge: some View {
        HexagonShape()
            .fill(Color.acmeNavy)
            .frame(width: 80, height: 80)
            .overlay(
                Text("A")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
            )
            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    LoginView()
}
