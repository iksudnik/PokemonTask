import SwiftUI

public struct MainButtonStyle: ButtonStyle {
	public func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.system(size: 16, weight: .semibold))
			.foregroundStyle(.black)
			.padding(.horizontal, 18)
			.padding(.vertical, 12)
			.background(
				RoundedRectangle(cornerRadius: 6)
					.fill(.accent)
					.saturation(configuration.isPressed ? 3 : 1)
			)
	}
}

public extension ButtonStyle where Self == MainButtonStyle {
	static var main: Self {
		return .init()
	}
}


#Preview {
	Button(action: {

	}, label: {
		Text("Sign In or Register")
			.foregroundStyle(.black)
	})
	.buttonStyle(.main)
}

