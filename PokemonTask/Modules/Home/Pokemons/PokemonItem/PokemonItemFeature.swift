//
//  PokemonItemFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 28.03.24.
//

import ComposableArchitecture

@Reducer
struct PokemonItemFeature {
	@ObservableState
	struct State: Equatable, Identifiable {
		var id: Pokemon.ID { pokemon.id }
		var pokemon: Pokemon
		var connectButton: PokemonConnectButtonFeature.State

		init(pokemon: Pokemon) {
			self.pokemon = pokemon
			connectButton = .init(pokemon: pokemon)
		}
	}

	@CasePathable
	enum Action {
		case connectButton(PokemonConnectButtonFeature.Action)
	}

	var body: some ReducerOf<Self> {

		Scope(state: \.connectButton, action: \.connectButton) {
			PokemonConnectButtonFeature()
		}

		Reduce { state, action in
			switch action {
			case .connectButton:
				return .none
			}
		}
	}
}

