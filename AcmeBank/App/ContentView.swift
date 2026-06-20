import SwiftUI

/// Bootstrap Hello World screen.
/// Replaced in future feature stories when the MVVM + Coordinator
/// architecture (AppCoordinator → LoginCoordinator / TabBarCoordinator) lands.
struct ContentView: View {
    var body: some View {
        Text("AcmeBank")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ContentView()
}
