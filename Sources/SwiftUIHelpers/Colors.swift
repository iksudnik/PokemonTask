import SwiftUI

public extension Color {
    static var accent: Color {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return Color(hex: "#DDFE56")
        } else {
			return Color.yellow
        }
    }
}

public extension ShapeStyle where Self == Color {
	static var accent: Color { .accent }
}


extension Color {
	init(hex: String) {
		var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
		var rgb: UInt64 = 0

		Scanner(string: cleanHexCode).scanHexInt64(&rgb)

		let redValue = Double((rgb >> 16) & 0xFF) / 255.0
		let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
		let blueValue = Double(rgb & 0xFF) / 255.0
		self.init(red: redValue, green: greenValue, blue: blueValue)
	}
}
