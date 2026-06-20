import SwiftUI

/// A reusable password input field that can toggle between masked and revealed text.
struct PasswordFieldView: View {
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                // Use an if/else branch so only one field exists in the view hierarchy
                // at a time. An opacity-zero view stays in the responder chain and can
                // surface the password in the QuickType/predictive-text suggestions bar.
                if isVisible {
                    // Plain (revealed) field
                    TextField(placeholder, text: $text)
                } else {
                    // Secure (masked) field
                    SecureField(placeholder, text: $text)
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            // Eye toggle button — minimum 44×44 pt touch target
            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundColor(.secondary)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(isVisible ? "Hide password" : "Show password")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(UIColor.systemGray4), lineWidth: 1)
        )
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var isVisible = false

    PasswordFieldView(
        placeholder: "Password",
        text: $text,
        isVisible: $isVisible
    )
    .padding()
}
