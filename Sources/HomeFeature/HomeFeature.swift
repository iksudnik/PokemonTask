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

		public var isLoading: Bool
		public var dataDidLoad: Bool

		public init(topBar: HomeTopBarFeature.State = HomeTopBarFeature.State(),
					featuredEvent: FeaturedEventFeature.State? = nil,
					events: EventsListFeature.State? = nil,
					pokemons: PokemonsListFeature.State? = nil,
					path: StackState<Path.State> = StackState<Path.State>(),
					isLoading: Bool = false,
					dataDidLoad: Bool = false) {
			self.topBar = topBar
			self.featuredEvent = featuredEvent
			self.events = events
			self.pokemons = pokemons
			self.path = path
			self.isLoading = isLoading
			self.dataDidLoad = dataDidLoad
		}
	}

	@CasePathable
	public enum Action {
		case topBar(HomeTopBarFeature.Action)
		case featuredEvent(FeaturedEventFeature.Action)
		case events(EventsListFeature.Action)
		case pokemons(PokemonsListFeature.Action)

		case path(StackAction<Path.State, Path.Action>)

		case onAppear
		case initialFetchResponse(Result<HomeResponse, Error>)
	}

	@Dependency(\.repository) var repository

	public init() {}

	public var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .onAppear:
				guard !state.dataDidLoad else {
					return .none
				}

				state.isLoading = true
				return .run { send in
					let result = await Result { try await repository.homeData() }
					await send(.initialFetchResponse(result))
				}

			case let .initialFetchResponse(result):
				state.isLoading = false
				state.dataDidLoad = true

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
