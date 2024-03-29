import ComposableArchitecture
import Models
import PokemonConnectButtonFeature

@Reducer
public struct PokemonDetailsFeature {

	@ObservableState
	public struct State: Equatable {
		public var pokemon: Pokemon
		public var connectButton: PokemonConnectButtonFeature.State

		public init(pokemon: Pokemon) {
			self.pokemon = pokemon
			connectButton = .init(pokemon: pokemon)
		}
	}

	public enum Action {
		case connectButton(PokemonConnectButtonFeature.Action)
	}

	public init() {}

	public var body: some ReducerOf<Self> {

		Scope(state: \.connectButton, action: \.connectButton) {
			PokemonConnectButtonFeature()
		}

		Reduce { state, action in
			switch action {
			case let .connectButton(.delegate(.updateIsConnected(isConnected))):
				state.pokemon.isConnected = isConnected
				return .none

			case .connectButton:
				return .none
			}
		}
	}
}
