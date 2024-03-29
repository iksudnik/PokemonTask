//
//  PokemonConnectButton.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 28.03.24.
//

import ComposableArchitecture
import SwiftUI

//MARK: - Reducer

@Reducer
struct PokemonConnectButtonFeature {
	@ObservableState
	struct State: Equatable {
		var pokemon: Pokemon
	}
	
	@CasePathable
	enum Action {
		case tapped
		case delegate(Delegate)
		
		@CasePathable
		enum Delegate {
			case updateIsConnected(Bool)
		}
	}
	
	@Dependency(\.repository) var repository
	
	var body: some ReducerOf<Self> {
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

struct PokemonConnectButton: View {
	let store: StoreOf<PokemonConnectButtonFeature>
	
	var body: some View {
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
