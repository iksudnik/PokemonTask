import ComposableArchitecture
import Mocks
import SwiftUI
import SwiftUIHelpers

public struct HomeTopBarView: View {
	let store: StoreOf<HomeTopBarFeature>

	public init(store: StoreOf<HomeTopBarFeature>) {
		self.store = store
	}

	public var body: some View {
		HStack {
			if !store.locations.isEmpty {
				HStack(spacing: 8) {
					Image(systemName: "map")

					DropdownMenu(items: store.locations) { location in
						store.send(.delegate(.locationSelected(location)))
					}
				}
				.font(.system(size: 24))
			}
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
		initialState: HomeTopBarFeature.State(locations: .mock)) {
			HomeTopBarFeature()
		})
}
