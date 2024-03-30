import ComposableArchitecture
import RepositoryClient
import Models

@Reducer
public struct PokemonsListFeature {
	@ObservableState
	public struct State: Equatable {
		public var pokemons: IdentifiedArrayOf<Pokemon>

		public init(pokemons: IdentifiedArrayOf<Pokemon> = []) {
			self.pokemons = pokemons
		}
	}

	@CasePathable
	public enum Action {
		case pokemonConnectButtonTapped(Pokemon)
		case updatePokemon(Pokemon)
		case delegate(Delegate)

		@CasePathable
		public enum Delegate {
			case pokemonTapped(Pokemon)
		}
	}

	@Dependency(\.repository) var repository

	public init() {}

	public var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {

			case let .updatePokemon(pokemon):
				state.pokemons[id: pokemon.id] = pokemon
				return .none

			case let .pokemonConnectButtonTapped(pokemon):
				return .run { [pokemon] send in
					var updatedPokemon = pokemon
					updatedPokemon.isConnected.toggle()
					try await repository.updatePokemonIsConnected(updatedPokemon.isConnected, updatedPokemon.id)
					await send(.updatePokemon(updatedPokemon))
				}

			case .delegate:
				return .none
			}
		}
	}
}
