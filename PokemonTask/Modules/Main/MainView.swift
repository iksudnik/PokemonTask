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
	
	@ObservableState
	struct State: Equatable {
		init(selection: MainReducer.Selection = .home,
			 homeTab: HomeReducer.State = .init(),
			 searchTab: SearchReducer.State = .init(),
			 ticketsTab: TicketsReducer.State = .init()) {
			self.selection = selection
			self.homeTab = homeTab
			self.searchTab = searchTab
			self.ticketsTab = ticketsTab
		}
		
		public var selection: Selection
		public var homeTab: HomeReducer.State
		public var searchTab: SearchReducer.State
		public var ticketsTab: TicketsReducer.State
	}
	
	@CasePathable
	enum Action {
		case homeTab(HomeReducer.Action)
		case searchTab(SearchReducer.Action)
		case ticketsTab(TicketsReducer.Action)
	}
	
	public enum Selection: Hashable {
		case home
		case search
		case tickets
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
	@Bindable var store: StoreOf<MainReducer>
	
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
