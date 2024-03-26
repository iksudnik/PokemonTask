//
//  MainView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct MainReducer {
	struct State: Equatable {
		var homeTab = HomeReducer.State()
		var searchTab = SearchReducer.State()
		var ticketsTab = TicketsReducer.State()
	}
	enum Action {
		case homeTab(HomeReducer.Action)
		case searchTab(SearchReducer.Action)
		case ticketsTab(TicketsReducer.Action)

	}
	var body: some ReducerOf<Self> {
		Scope(state: \.homeTab, action: \.homeTab) {
			HomeReducer()
		}
		Scope(state: \.searchTab, action: \.searchTab) {
			SearchReducer()
		}
		Scope(state: \.ticketsTab, action: \.ticketsTab) {
			TicketsReducer()
		}
		Reduce { state, action in
			// Core logic of the app feature
			return .none
		}
	}
}

struct MainView: View {
	let store: StoreOf<MainReducer>

	var body: some View {
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
	MainView(store: Store(
		initialState: MainReducer.State()) {
			MainReducer()
		}
	)
}
