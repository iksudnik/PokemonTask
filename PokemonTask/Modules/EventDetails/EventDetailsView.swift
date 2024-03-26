//
//  EventDetailsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct EventDetailsReducer {
	@ObservableState
	struct State: Equatable {
		var event: Event
		var isLoading = false
		var pokemons: PokemonsListReducer.State?
	}

	enum Action {
		case initialFetch
		case pokemonsResponse(Result<[Pokemon], Error>)
		case pokemons(PokemonsListReducer.Action)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {

			case .initialFetch:
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
			PokemonsListReducer()
		}
	}
}

// MARK: - View

struct EventDetailsView: View {
	let store: StoreOf<EventDetailsReducer>
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Color.secondary
					.aspectRatio(1, contentMode: .fit)
					.overlay {
						Image(store.event.image)
							.resizable()
							.scaledToFill()
					}
					.clipped()

				VStack(alignment: .leading, spacing: 4) {
					Text(store.event.title)
						.font(.system(size: 16))
						.multilineTextAlignment(.leading)
					Group {
						Text(store.event.dateString)
						Text(store.event.location)
					}
					.font(.system(size: 16))
					.foregroundStyle(.secondary)

					if let store = store.scope(state: \.pokemons, action: \.pokemons) {
						SectionView(title: "Featured Pokemons") {
							PokemonsView(store: store)
						}
						.padding(.top, 16)
					}
				}
				.padding(.horizontal, 16)
			}
		}
		.ignoresSafeArea(edges: .top)
		.navigationTitle(store.event.title)
		.scrollIndicators(.hidden)
		.task {
			store.send(.initialFetch)
		}
	}
}

// MARK: - Previews

#Preview {
	EventDetailsView(store: Store(
		initialState: EventDetailsReducer.State(event: .event1)) {
			EventDetailsReducer()
		}
	)
}
