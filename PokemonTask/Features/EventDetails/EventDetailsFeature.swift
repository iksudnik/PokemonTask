//
//  EventDetailsFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct EventDetailsFeature {
	@ObservableState
	struct State: Equatable {
		var event: Event
		var isLoading = false
		var pokemons: PokemonsListFeature.State?
	}

	@CasePathable
	enum Action {
		case onAppear
		case pokemonsResponse(Result<[Pokemon], Error>)
		case pokemons(PokemonsListFeature.Action)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {

			case .onAppear:
				state.isLoading = true
				return .run { [pokemonIDs = state.event.pokemonIds] send in
					let result = await Result { try await repository.pokemons(pokemonIDs) }
					return await send(.pokemonsResponse(result))
				}

			case let .pokemonsResponse(result):
				switch result {
				case let .success(pokemons):
					state.pokemons = .init(pokemons: .init(
						uniqueElements: pokemons.map { .init(pokemon: $0) }
					))
					return .none

				case .failure:
					return .none
				}

			case .pokemons:
				return .none
			}
		}
		.ifLet(\.pokemons, action: \.pokemons) {
			PokemonsListFeature()
		}
	}
}
