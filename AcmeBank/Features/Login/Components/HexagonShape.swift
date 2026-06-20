import SwiftUI

/// A regular-hexagon `Shape` used as the container for the AcmeBank logo badge.
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        for i in 0..<6 {
            // Flat-top hexagon: start at -90° so the top is flat (point up).
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    HexagonShape()
        .fill(Color(hex: "#1B2A4A"))
        .frame(width: 80, height: 80)
        .overlay(
            Text("A")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
        )
        .padding()
}
