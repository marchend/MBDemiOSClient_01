import SwiftUI

/// Static top-strip showing the Okta domain address with a lock icon.
struct OktaAddressBar: View {
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.systemGray))
                Text("acmebank.okta.com")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.systemGray))
            }

            Spacer()

            Text("okta")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color(UIColor.darkGray))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(UIColor.systemGray6))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(UIColor.systemGray4)),
            alignment: .bottom
        )
    }
}

#Preview {
    OktaAddressBar()
}
