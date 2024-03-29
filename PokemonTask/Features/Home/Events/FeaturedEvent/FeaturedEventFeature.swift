//
//  FeaturedEventFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct FeaturedEventFeature {
	@ObservableState
	struct State: Equatable {
		var event: FeaturedEvent
	}

	enum Action {
		case delegate(Delegate)

		@CasePathable
		enum Delegate {
			case eventTapped(Event)
		}
	}
}
