import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension ShapeStyle where Self == Color {
    static var appBackground: Color { Color(hex: "FAFAF8") }
    static var appBackgroundDark: Color { Color(hex: "1C1C1E") }
    static var depthLight: Color { Color(hex: "FFD60A") }
    static var depthMedium: Color { Color(hex: "FF9F0A") }
    static var depthDeep: Color { Color(hex: "BF5AF2") }
}
