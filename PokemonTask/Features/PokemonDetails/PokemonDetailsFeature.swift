//
//  PokemonDetailsFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct PokemonDetailsFeature {

	@ObservableState
	struct State: Equatable {
		var pokemon: Pokemon
		var connectButton: PokemonConnectButtonFeature.State

		init(pokemon: Pokemon) {
			self.pokemon = pokemon
			connectButton = .init(pokemon: pokemon)
		}
	}

	enum Action {
		case connectButton(PokemonConnectButtonFeature.Action)
	}

	var body: some ReducerOf<Self> {

		Scope(state: \.connectButton, action: \.connectButton) {
			PokemonConnectButtonFeature()
		}

		Reduce { state, action in
			switch action {
			case let .connectButton(.delegate(.updateIsConnected(isConnected))):
				state.pokemon.isConnected = isConnected
				return .none

			case .connectButton:
				return .none
			}
		}
	}
}
