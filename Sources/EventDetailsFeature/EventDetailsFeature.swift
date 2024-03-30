import ComposableArchitecture
import Models
import PokemonsListFeature
import RepositoryClient

@Reducer
public struct EventDetailsFeature {
	@ObservableState
	public struct State: Equatable {
		public var event: Event
		public var isLoading: Bool
		public var pokemons: PokemonsListFeature.State?

		public init(event: Event,
					isLoading: Bool = false,
					pokemons: PokemonsListFeature.State? = nil) {
			self.event = event
			self.isLoading = isLoading
			self.pokemons = pokemons
		}
	}

	@CasePathable
	public enum Action {
		case onTask
		case pokemonsResponse(Result<[Pokemon], Error>)
		case pokemons(PokemonsListFeature.Action)
	}

	@Dependency(\.repository) var repository

	public init() {}

	public var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {

			case .onTask:
				state.isLoading = true
				return .run { [pokemonIDs = state.event.pokemonIds] send in
					let result = await Result { try await repository.pokemons(pokemonIDs) }
					return await send(.pokemonsResponse(result))
				}

			case let .pokemonsResponse(result):
				switch result {
				case let .success(pokemons):
					state.pokemons = .init(pokemons: .init(uniqueElements: pokemons))
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
