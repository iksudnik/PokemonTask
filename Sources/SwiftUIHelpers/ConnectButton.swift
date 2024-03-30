import SwiftUI

public struct ConnectButton: View {
	var isConnected: Bool
	let action: () -> Void

	public init(isConnected: Bool, action: @escaping () -> Void) {
		self.isConnected = isConnected
		self.action = action
	}

	public var body: some View {
		Button(action: action, label: {
			Text(isConnected ? "Connected" : "Connect")
				.frame(maxWidth: .infinity)
		})
		.buttonStyle(.main)
	}
}

// MARK: - Preview

#Preview {
	return ConnectButton(isConnected: false, action: { })
		.frame(width: 150)
}
