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
		var nextUrl: URL?
		var totalCount: Int = Int.max
		var pokemons: IdentifiedArrayOf<PokemonItemReducer.State> = []

		var canDownloadMore: Bool {
			nextUrl != nil && pokemons.count < totalCount
		}
	}

	enum Action {
		case initialFetch
		case nextFetch
		case pokemonsResponse(Result<PokemonResponse, Error>)
		case pokemons(IdentifiedActionOf<PokemonItemReducer>)
		case updateIsConnected(Bool, Int)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .initialFetch:
				return .run { send in
					let result = await Result { try await repository.pokemons(.initial()) }
					await send(.pokemonsResponse(result))
				}

			case .nextFetch:
				guard state.canDownloadMore,
					  let nextUrl = state.nextUrl else {
					return .none
				}
				return .run { send in
					let result = await Result { try await repository.pokemons(.next(nextUrl)) }
					await send(.pokemonsResponse(result))
				}

			case let .pokemonsResponse(result):
				switch result {
				case let .success(response):
					let pokemonStates: [PokemonItemReducer.State] = response.results
						.map { .init(pokemon: $0) }
					state.pokemons.append(contentsOf: pokemonStates)
					state.nextUrl = response.next
					state.totalCount = response.count
					return .none
				case .failure:
					return .none
				}

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
				}
				if store.canDownloadMore {
					ProgressView()
						.padding(.horizontal)
						.onAppear {
							store.send(.nextFetch)
						}
				}
			}
		}
		.scrollIndicators(.never)
		.task {
			store.send(.initialFetch)
		}
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
