import ComposableArchitecture
import Models
import RepositoryClient

@Reducer
public struct PokemonDetailsFeature : Sendable {

	@ObservableState
	public struct State: Equatable {
		public var pokemon: Pokemon

		public init(pokemon: Pokemon) {
			self.pokemon = pokemon
		}
	}

	public enum Action : Sendable {
		case connectButtonTapped
		case updatePokemon(Pokemon)
	}

	@Dependency(\.repository) var repository

	public init() {}

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case let .updatePokemon(pokemon):
				state.pokemon = pokemon
				return .none

			case .connectButtonTapped:
				return .run { [pokemon = state.pokemon] send in
					var updatedPokemon = pokemon
					updatedPokemon.isConnected.toggle()
					try await repository.updatePokemonIsConnected(updatedPokemon.isConnected, updatedPokemon.id)
					await send(.updatePokemon(updatedPokemon))
				}
			}
		}
	}
}
