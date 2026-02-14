import SwiftUI

struct Theme {
    // Colors - Light Mode
    static let primaryBlue = Color(hex: "0A7AFF")
    static let secondaryCyan = Color(hex: "5AC8FA")
    static let accentGreen = Color(hex: "34C759")
    static let backgroundLight = Color(hex: "F2F2F7")
    static let surfaceWhite = Color.white
    static let textPrimary = Color.black
    static let textSecondary = Color(hex: "8E8E93")
    static let warningOrange = Color(hex: "FF9500")
    static let errorRed = Color(hex: "FF3B30")
    
    // Water Gradients - Light
    static let waterGradientLow = LinearGradient(
        colors: [Color(hex: "E3F2FD"), Color(hex: "BBDEFB")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let waterGradientMid = LinearGradient(
        colors: [Color(hex: "64B5F6"), Color(hex: "42A5F5")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let waterGradientHigh = LinearGradient(
        colors: [Color(hex: "2196F3"), Color(hex: "1976D2")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let waterGradientComplete = LinearGradient(
        colors: [Color(hex: "00BCD4"), Color(hex: "0097A7")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Spacing
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32
    
    // Corner Radius
    static let radiusS: CGFloat = 8
    static let radiusM: CGFloat = 12
    static let radiusL: CGFloat = 16
    static let radiusXL: CGFloat = 20
    
    // Animation Durations
    static let animationFast: Double = 0.3
    static let animationMedium: Double = 0.5
    static let animationSlow: Double = 1.2
    
    static func apply() {
        // Any global theme setup
    }
    
    static func waterGradient(for percentage: Double) -> LinearGradient {
        switch percentage {
        case 0..<0.25:
            return waterGradientLow
        case 0.25..<0.75:
            return waterGradientMid
        case 0.75..<1.0:
            return waterGradientHigh
        default:
            return waterGradientComplete
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
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
