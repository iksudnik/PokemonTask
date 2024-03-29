import ComposableArchitecture
import SwiftUI
import SwiftUIHelpers

public struct HomeTopBarView: View {
	let store: StoreOf<HomeTopBarFeature>

	public init(store: StoreOf<HomeTopBarFeature>) {
		self.store = store
	}

	public var body: some View {
		HStack {
			HStack(spacing: 8) {
				Image(systemName: "map")

				Text("Kanto")
					.font(.system(size: 20, weight: .semibold))
					.padding(.bottom, 4)
					.overlay(
						Rectangle()
							.frame(height: 2)
							.foregroundColor(.primary),
						alignment: .bottom
					)
			}
			.font(.system(size: 24))
			Spacer()
			if store.isLoggedIn {
				Circle()
			} else {
				Button(action: {
					store.send(.delegate(.loginButtonTapped))
				}, label: {
					Text("Sign In or Register")
				})
				.buttonStyle(.main)
			}
		}
	}
}

#Preview {
	HomeTopBarView(store: Store(
		initialState: HomeTopBarFeature.State()) {
			HomeTopBarFeature()
		})
}
