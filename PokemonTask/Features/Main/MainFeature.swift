//
//  MainFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct MainFeature {

	@ObservableState
	struct State: Equatable {
		init(selection: MainFeature.Selection = .home,
			 homeTab: HomeFeature.State = .init(),
			 searchTab: SearchFeature.State = .init(),
			 ticketsTab: TicketsFeature.State = .init()) {
			self.selection = selection
			self.homeTab = homeTab
			self.searchTab = searchTab
			self.ticketsTab = ticketsTab
		}

		public var selection: Selection
		public var homeTab: HomeFeature.State
		public var searchTab: SearchFeature.State
		public var ticketsTab: TicketsFeature.State
	}

	@CasePathable
	enum Action {
		case homeTab(HomeFeature.Action)
		case searchTab(SearchFeature.Action)
		case ticketsTab(TicketsFeature.Action)
	}

	enum Selection: Hashable {
		case home
		case search
		case tickets
	}

	var body: some ReducerOf<Self> {
		Scope(state: \.homeTab, action: \.homeTab) {
			HomeFeature()
		}

		Scope(state: \.searchTab, action: \.searchTab) {
			SearchFeature()
		}
		
		Scope(state: \.ticketsTab, action: \.ticketsTab) {
			TicketsFeature()
		}

		Reduce { state, action in
			return .none
		}
	}
}
