import SwiftUI

/// Static bottom footer indicating the authentication is powered by Okta.
struct SecuredByOktaFooter: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Secured by")
                .font(.caption)
                .foregroundColor(Color(UIColor.systemGray))
            Text("okta")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color(UIColor.darkGray))
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    SecuredByOktaFooter()
}
