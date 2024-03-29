//
//  HomeTopBarFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct HomeTopBarFeature {
	@ObservableState
	struct State: Equatable {
		var isLoggedIn = false
	}

	enum Action {
		case delegate(Delegate)

		@CasePathable
		enum Delegate {
			case loginButtonTapped
		}
	}
}

