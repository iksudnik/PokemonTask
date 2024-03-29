//
//  PokemonsListFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 28.03.24.
//

import ComposableArchitecture

@Reducer
struct PokemonsListFeature {
	@ObservableState
	struct State: Equatable {
		var pokemons: IdentifiedArrayOf<PokemonItemFeature.State> = []
	}

	@CasePathable
	enum Action {
		case pokemons(IdentifiedActionOf<PokemonItemFeature>)
		case delegate(Delegate)

		@CasePathable
		enum Delegate {
			case pokemonTapped(Pokemon)
		}
	}

	var body: some ReducerOf<Self> {

		EmptyReducer()
		.forEach(\.pokemons, action: \.pokemons) {
			PokemonItemFeature()
		}
	}
}
