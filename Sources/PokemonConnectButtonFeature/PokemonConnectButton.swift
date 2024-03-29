import ComposableArchitecture
import Models
import RepositoryClient
import SwiftUI
import SwiftUIHelpers

//MARK: - Reducer

@Reducer
public struct PokemonConnectButtonFeature {
	@ObservableState
	public struct State: Equatable {
		public var pokemon: Pokemon
		
		public  init(pokemon: Pokemon) {
			self.pokemon = pokemon
		}
	}
	
	@CasePathable
	public enum Action {
		case tapped
		case delegate(Delegate)
		
		@CasePathable
		public enum Delegate {
			case updateIsConnected(Bool)
		}
	}
	
	@Dependency(\.repository) var repository

	public init() {}

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .tapped:
				return .run { [pokemon = state.pokemon] send in
					let isConnected = !pokemon.isConnected
					try await repository.updatePokemonIsConnected(isConnected, pokemon.id)
					await send(.delegate(.updateIsConnected(isConnected)), animation: .snappy)
				}
				
			case let .delegate(.updateIsConnected(isConnected)):
				state.pokemon.isConnected = isConnected
				return .none
			}
		}
	}
}


// MARK: - View

public struct PokemonConnectButton: View {
	let store: StoreOf<PokemonConnectButtonFeature>

	public init(store: StoreOf<PokemonConnectButtonFeature>) {
		self.store = store
	}

	public var body: some View {
		Button(action: {
			store.send(.tapped)
		}, label: {
			Text(store.pokemon.isConnected ? "Connected" : "Connect")
				.frame(maxWidth: .infinity)
		})
		.buttonStyle(.main)
	}
}

// MARK: - Preview

#Preview {
	PokemonConnectButton(store: Store(initialState: .init(pokemon: .bulbasaur)) {
		PokemonConnectButtonFeature()
	})
}
