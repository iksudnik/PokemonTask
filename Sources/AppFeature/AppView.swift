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
		TabView {
			HomeView(store: store.scope(state: \.homeTab, action: \.homeTab))
				.tabItem { Label("HOME", systemImage: "house") }

			SearchView(store: store.scope(state: \.searchTab, action: \.searchTab))
				.tabItem { Label("SEARCH", systemImage: "magnifyingglass")}
			
			TicketsView(store: store.scope(state: \.ticketsTab, action: \.ticketsTab))
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
