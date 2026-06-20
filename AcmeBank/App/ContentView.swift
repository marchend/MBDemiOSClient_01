import SwiftUI

/// Root content view — presents `LoginView` as the first screen on launch.
///
/// The `onSignIn` closure is a no-op stub until the Okta authentication
/// story wires up the real `DirectAuthenticationFlow`. At that point this
/// view will be replaced by the `AppCoordinator`-driven root that routes
/// between the Login flow and the authenticated tab-bar.
struct ContentView: View {
    var body: some View {
        LoginView(onSignIn: { _, _ in })
    }
}

#Preview {
    ContentView()
}
