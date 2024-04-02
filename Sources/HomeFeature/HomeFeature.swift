import ComposableArchitecture
import FeaturedEventFeature
import HomeTopBarFeature
import EventDetailsFeature
import EventsListFeature
import Models
import PokemonDetailsFeature
import PokemonsListFeature

@Reducer
public struct HomeFeature {

	@Reducer(state: .equatable)
	public enum Path {
		case eventDetails(EventDetailsFeature)
		case pokemonDetails(PokemonDetailsFeature)
	}

	@ObservableState
	public struct State: Equatable {
		public var topBar: HomeTopBarFeature.State
		public var featuredEvent: FeaturedEventFeature.State?
		public var events: EventsListFeature.State?
		public var pokemons: PokemonsListFeature.State?

		public var path: StackState<Path.State>

		public var loadingState: LoadingState

		public init(topBar: HomeTopBarFeature.State = HomeTopBarFeature.State(),
					featuredEvent: FeaturedEventFeature.State? = nil,
					events: EventsListFeature.State? = nil,
					pokemons: PokemonsListFeature.State? = nil,
					path: StackState<Path.State> = StackState<Path.State>(),
					loadingState: LoadingState = .idle) {
			self.topBar = topBar
			self.featuredEvent = featuredEvent
			self.events = events
			self.pokemons = pokemons
			self.path = path
			self.loadingState = loadingState
		}
	}

	public enum LoadingState: Equatable {
		case idle
		case loaded
	}

	@CasePathable
	public enum Action {
		case topBar(HomeTopBarFeature.Action)
		case featuredEvent(FeaturedEventFeature.Action)
		case events(EventsListFeature.Action)
		case pokemons(PokemonsListFeature.Action)

		case path(StackAction<Path.State, Path.Action>)

		case onTask
		case homeResponseResult(Result<HomeResponse, Error>)
	}

	@Dependency(\.repository) var repository

	public init() {}

	public var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .onTask:
				return .run { send in
					let result = await Result { try await repository.homeData() }
					await send(.homeResponseResult(result))
				}

			case let .homeResponseResult(result):
				state.loadingState = .loaded

				switch result {
				case let .success(response):
					state.topBar.locations = response.locations
					state.featuredEvent = .init(event: response.featuredEvent)
					state.events = .init(events: .init(
						uniqueElements: response.weaklyEvents
					))
					if !response.popularPokemons.isEmpty {
						state.pokemons = .init(pokemons: .init(
							uniqueElements: response.popularPokemons
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
				case .locationSelected:
					return .none
				}

			case let .events(.delegate(.eventTapped(event))):
				state.path.append(.eventDetails(EventDetailsFeature.State(event: event)))
				return .none

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
