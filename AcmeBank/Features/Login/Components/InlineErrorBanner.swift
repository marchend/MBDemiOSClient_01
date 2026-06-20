import SwiftUI

/// A collapsible monochrome error banner.
/// When `message` is `nil` the view collapses to zero height and adds no spacing.
struct InlineErrorBanner: View {
    let message: String?

    var body: some View {
        if let message {
            Text(message)
                .font(.footnote)
                .foregroundColor(Color(UIColor.darkGray))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(UIColor.systemGray3), lineWidth: 1)
                )
                .accessibilityLabel("Error: \(message)")
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        InlineErrorBanner(message: "Invalid username or password. Please try again.")
        InlineErrorBanner(message: nil)
            .background(Color.yellow.opacity(0.3)) // Invisible — zero height
    }
    .padding()
}
