import SwiftUI

struct ButtonStyleViewModifier: ButtonStyle {

	let scale: CGFloat

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? scale : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

public extension View {
	func asButton(scale: CGFloat = 0.95,
				  action: @escaping () -> Void) -> some View {
		Button(action: {
			action()
		}, label: {
			self
		})
		.buttonStyle(ButtonStyleViewModifier(scale: scale))
	}
}

#Preview {
	let someButtonLabel: some View  = {
		Text("Hello")
			.foregroundColor(.white)
			.frame(height: 52)
			.frame(maxWidth: .infinity)
			.background(Color.blue)
			.cornerRadius(10)
	}()

	return someButtonLabel
		.asButton { }
		.padding()
}
