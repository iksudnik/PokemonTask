//
//  HomeFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import ComposableArchitecture

@Reducer
struct HomeFeature {

	@Reducer(state: .equatable)
	enum Path {
		case eventDetails(EventDetailsFeature)
		case pokemonDetails(PokemonDetailsFeature)
	}

	@ObservableState
	struct State: Equatable {
		var topBar = HomeTopBarFeature.State()
		var featuredEvent: FeaturedEventFeature.State?
		var events: EventsListFeature.State?
		var pokemons: PokemonsListFeature.State?

		var path = StackState<Path.State>()

		var isLoading = false
	}

	@CasePathable
	enum Action {
		case onAppear
		case topBar(HomeTopBarFeature.Action)
		case featuredEvent(FeaturedEventFeature.Action)
		case events(EventsListFeature.Action)
		case pokemons(PokemonsListFeature.Action)

		case path(StackAction<Path.State, Path.Action>)

		case initialFetchResponse(Result<HomeResponse, Error>)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .onAppear:
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
					state.path.append(.eventDetails(EventDetailsFeature.State(event: event)))
					return .none
				}

			case let .featuredEvent(.delegate(.eventTapped(event))):
				state.path.append(.eventDetails(EventDetailsFeature.State(event: event)))
				return .none

			case let .pokemons(.delegate(.pokemonTapped(pokemon))):
				state.path.append(.pokemonDetails(.init(pokemon: pokemon)))
				return .none

			case let .path(.element(id: _, action: .eventDetails(
				.pokemons(.delegate(.pokemonTapped(pokemon)))))):
				state.path.append(.pokemonDetails(.init(pokemon: pokemon)))
				return .none

			case .path:
				return .none

			case .pokemons:
				return .none
			}
		}
		.ifLet(\.pokemons, action: \.pokemons) {
			PokemonsListFeature()
		}
		.forEach(\.path, action: \.path)
	}
}
