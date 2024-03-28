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

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {

			case .pokemons:
				return .none
				
			case .delegate:
				return .none
			}
		}
		.forEach(\.pokemons, action: \.pokemons) {
			PokemonItemFeature()
		}
	}
}
