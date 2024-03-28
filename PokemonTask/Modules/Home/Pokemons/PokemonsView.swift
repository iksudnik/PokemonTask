//
//  PokemonsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct PokemonConnectionReducer {
	@ObservableState
	struct State: Equatable {
		var pokemon: Pokemon
	}

	@CasePathable
	enum Action {
		case connect
		case delegate(Delegate)

		@CasePathable
		enum Delegate {
			case updateIsConnected(Bool, Pokemon.ID)
		}
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .connect:
				return .run { [pokemon = state.pokemon] send in
					let isConnected = !pokemon.isConnected
					try await repository.updatePokemonIsConnected(isConnected, pokemon.id)
					await send(.delegate(.updateIsConnected(isConnected, pokemon.id)))
				}

			case .delegate:
				return .none
			}
		}
	}
}

// MARK: - Reducer

@Reducer
struct PokemonsListReducer {
	@ObservableState
	struct State: Equatable {
		var pokemons: IdentifiedArrayOf<PokemonItemReducer.State> = []
		var pokemonConnection: PokemonConnectionReducer.State?
	}

	@CasePathable
	enum Action {
		case pokemons(IdentifiedActionOf<PokemonItemReducer>)
		case pokemonConnection(PokemonConnectionReducer.Action)
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

			case let .pokemons(.element(id: id,
										action: .delegate(.connectButtonTapped))):
				if let pokemon = state.pokemons[id: id]?.pokemon {
					state.pokemonConnection = .init(pokemon: pokemon)
					return .send(.pokemonConnection(.connect))
				}
				return .none

			case let .pokemonConnection(.delegate(.updateIsConnected(isConnected, id))):
				withAnimation(.snappy) {
					state.pokemons[id: id]?.pokemon.isConnected = isConnected
				}
				return.none

			case .pokemons:
				return .none

			case .pokemonConnection:
				return .none

			case .delegate:
				return .none
			}
		}
		.forEach(\.pokemons, action: \.pokemons) {
			PokemonItemReducer()
		}
		.ifLet(\.pokemonConnection, action: \.pokemonConnection) {
			PokemonConnectionReducer()
		}
	}
}

// MARK: - View

struct PokemonsView: View {
	var store: StoreOf<PokemonsListReducer>

	private let spacing: CGFloat = 8

	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: spacing) {
				ForEach(store.scope(state: \.pokemons, action: \.pokemons)) { pokemon in
					PokemonView(store: pokemon)
						.containerRelativeFrame(.horizontal,
												count: 5,
												span: 2,
												spacing: spacing)
						.onTapGesture {
							store.send(.delegate(.pokemonTapped(pokemon.pokemon)))
						}
				}
			}
		}
		.scrollIndicators(.never)
	}
}

// MARK: - Previews

#Preview(traits: .sizeThatFitsLayout) {
	return PokemonsView(
		store: Store(
			initialState: PokemonsListReducer.State()) {
				PokemonsListReducer()
			}
	)
	.frame(height: 260)
}
