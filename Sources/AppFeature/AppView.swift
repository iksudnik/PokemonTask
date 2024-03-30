import ComposableArchitecture
import HomeFeature
import SearchFeature
import SwiftUI
import TicketsFeature

public struct AppView: View {
	@Bindable public var store: StoreOf<AppFeature>

	public init(store: StoreOf<AppFeature>) {
		self.store = store
	}

	public var body: some View {
		TabView(selection: $store.selection.sending(\.selected)) {
			HomeView(store: store.scope(state: \.home, action: \.home))
				.tabItem { Label("HOME", systemImage: "house") }

			SearchView(store: store.scope(state: \.search, action: \.search))
				.tabItem { Label("SEARCH", systemImage: "magnifyingglass")}
			
			TicketsView(store: store.scope(state: \.tickets, action: \.tickets))
				.tabItem { Label("TICKETS", systemImage: "ticket")}
		}
		.tint(.accent)
	}
}

#Preview {
	AppView(store: Store(
		initialState: AppFeature.State()) {
			AppFeature()
		}
	)
}
