//
//  EventsListFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct EventsListFeature {
	@ObservableState
	struct State: Equatable {
		var events: IdentifiedArrayOf<EventItemFeature.State> = []
	}

	enum Action {
		case events(IdentifiedActionOf<EventItemFeature>)
	}
}
