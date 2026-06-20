import SwiftUI

// MARK: - Hex initialiser

extension Color {
    /// Initialise a `Color` from a CSS-style hex string (e.g. `"#1B2A4A"` or `"1B2A4A"`).
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - AcmeBank palette
// The app is STRICTLY MONOCHROME — navy + white + greys ONLY.
// Do not add semantic colours (no red/green for amounts, badges, etc.).

extension Color {
    /// Logo, signed-in card, account-type tiles, avatars, primary button.
    static let acmeNavy       = Color(hex: "#1B2A4A")
    /// Screen background.
    static let acmeBackground = Color(hex: "#F2F3F5")
    /// Cards / input fields.
    static let acmeSurface    = Color.white
    /// All amounts + primary text (positive AND negative).
    static let acmeText       = Color(hex: "#1A1A1A")
    /// Secondary / caption text.
    static let acmeSubtext    = Color(hex: "#6B7280")
}
