//
//  EventItemFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct EventItemFeature {
	@ObservableState
	struct State: Equatable, Identifiable {
		var id: Event.ID { event.id }
		var event: Event
	}

	enum Action {
		case delegate(Delegate)

		@CasePathable
		enum Delegate {
			case eventTapped(Event)
		}
	}
}

