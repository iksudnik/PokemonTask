//
//  PokemonsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct PokemonsListReducer {
	@ObservableState
	struct State: Equatable {
		var pokemons: IdentifiedArrayOf<PokemonItemReducer.State> = []
	}

	@CasePathable
	enum Action {
		case pokemons(IdentifiedActionOf<PokemonItemReducer>)
		case updateIsConnected(Bool, Pokemon.ID)
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
										action: .delegate(delegateAction))):
				switch delegateAction {
				case .connectButtonTapped:
					guard let pokemon = state.pokemons[id: id]?.pokemon else {
						return .none
					}
					return .run { [pokemon, id] send in
						let isConnected = !pokemon.isConnected
						try await repository.updatePokemonIsConnected(isConnected, id)
						await send(.updateIsConnected(isConnected, id), animation: .smooth)
					}
				}
			case let .updateIsConnected(isConnected, id):
				state.pokemons[id: id]?.pokemon.isConnected = isConnected
				return .none
			case .delegate:
				return .none
			}
		}
		.forEach(\.pokemons, action: \.pokemons) {
			PokemonItemReducer()
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
