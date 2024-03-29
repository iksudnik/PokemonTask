import ComposableArchitecture
import Models
import PokemonItemFeature

@Reducer
public struct PokemonsListFeature {
	@ObservableState
	public struct State: Equatable {
		public var pokemons: IdentifiedArrayOf<PokemonItemFeature.State>

		public init(pokemons: IdentifiedArrayOf<PokemonItemFeature.State> = []) {
			self.pokemons = pokemons
		}
	}

	@CasePathable
	public enum Action {
		case pokemons(IdentifiedActionOf<PokemonItemFeature>)
		case delegate(Delegate)

		@CasePathable
		public enum Delegate {
			case pokemonTapped(Pokemon)
		}
	}

	public init() {}

	public var body: some ReducerOf<Self> {

		EmptyReducer()
		.forEach(\.pokemons, action: \.pokemons) {
			PokemonItemFeature()
		}
	}
}
