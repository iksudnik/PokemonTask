//
//  HomeView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct HomeReducer {

	@Reducer(state: .equatable)
	enum Path {
		case eventDetails(EventDetailsReducer)
		case pokemonDetails(PokemonDetailsReducer)
	}

	@ObservableState
	struct State: Equatable {
		var topBar = HomeTopBarReducer.State()
		var featuredEvent: FeaturedEventReducer.State?
		var events: EventsListReducer.State?
		var pokemons: PokemonsListReducer.State?

		var path = StackState<Path.State>()

		var isLoading = false
	}

	enum Action {
		case initialFetch
		case topBar(HomeTopBarReducer.Action)
		case featuredEvent(FeaturedEventReducer.Action)
		case events(EventsListReducer.Action)
		case pokemons(PokemonsListReducer.Action)

		case path(StackAction<Path.State, Path.Action>)

		case initialFetchResponse(Result<HomeResponse, Error>)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .initialFetch:
				state.isLoading = true
				return .run { send in
					let result = await Result { try await repository.homeData() }
					await send(.initialFetchResponse(result))
				}

			case let .initialFetchResponse(result):
				state.isLoading = false

				switch result {
				case let .success(response):
					state.featuredEvent = .init(event: response.featuredEvent)
					state.events = .init(events: .init(
						uniqueElements: response.weaklyEvents.map { .init(event: $0) }
					))
					if !response.popularPokemons.isEmpty {
						state.pokemons = .init(pokemons: .init(
							uniqueElements: response.popularPokemons.map { .init(pokemon: $0) }
						))
					}
					return .none
				case .failure:
					return .none
				}

			case let .topBar(.delegate(delegateAction)):
				switch delegateAction {
				case .loginButtonTapped:
					return .none
				}

			case let .events(.events(.element(_, action))):
				switch action {
				case let .delegate(.eventTapped(event)):
					state.path.append(.eventDetails(EventDetailsReducer.State(event: event)))
					return .none
				}

			case let .featuredEvent(.delegate(.eventTapped(event))):
				state.path.append(.eventDetails(EventDetailsReducer.State(event: event)))
				return .none

			case let .pokemons(.pokemons(.element(_, action))):
				switch action {
				case let .delegate(.pokemonTapped(pokemon)):
					state.path.append(.pokemonDetails(PokemonDetailsReducer.State(pokemon: pokemon)))
					return .none
				case .delegate(.connectButtonTapped):
					return .none
				}

			case .path:
				return .none

			case .pokemons:
				return .none
			}
		}
		.ifLet(\.pokemons, action: \.pokemons) {
			PokemonsListReducer()
		}
		.forEach(\.path, action: \.path)
	}
}

// MARK: - View

struct HomeView: View {
	@Bindable var store: StoreOf<HomeReducer>

	var body: some View {
		NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
			VStack {
				HomeTopBarView(store: store.scope(state: \.topBar,
												  action: \.topBar))
				.padding(.bottom, 16)

				ScrollView {
					VStack(spacing: 32) {
						if store.isLoading {
							Group {
								FeaturedEventView(store: Store(
									initialState: .init(event: .featured)) {
										EmptyReducer()
									})

								SectionView(title: "This Weak") {
									EventsView(store: Store(
										initialState: .init()) {
											EmptyReducer()
										})
								}

								SectionView(title: "Popular Pokemons") {
									PokemonsView(store: Store(
										initialState: PokemonsListReducer.State()) {
											PokemonsListReducer()
										})
								}
							}
							.redacted(reason: .placeholder)
						} else {
							if let store = store.scope(state: \.featuredEvent, action: \.featuredEvent) {
								FeaturedEventView(store: store)
							}

							if let store = store.scope(state: \.events, action: \.events) {
								SectionView(title: "This Weak") {
									EventsView(store: store)
								}
							}

							if let store = store.scope(state: \.pokemons, action: \.pokemons) {
								SectionView(title: "Popular Pokemon") {
									PokemonsView(store: store)
								}
							}
						}
					}
					.padding(.bottom, 32)
				}
				.scrollIndicators(.never)
			}
			.padding(.horizontal, 12)
			.background(Color(.systemGray6))
			.task {
				store.send(.initialFetch)
			}
		} destination: { store in
			switch store.case {
			case let .eventDetails(store):
				EventDetailsView(store: store)
			case let .pokemonDetails(store):
				PokemonDetailsView(store: store)
			}
		}

	}
}

// MARK: - Previews

#Preview {
	HomeView(
		store: Store(
			initialState: HomeReducer.State()
		) {
			HomeReducer()
		}
	)
}
