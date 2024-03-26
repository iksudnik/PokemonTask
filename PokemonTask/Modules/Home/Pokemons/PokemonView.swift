//
//  PokemonView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI
import SDWebImageSwiftUI

// MARK: - Reducer

@Reducer
struct PokemonItemReducer {
	@ObservableState
	struct State: Equatable, Identifiable {
		var id: Pokemon.ID { pokemon.id }
		var pokemon: Pokemon
	}

	enum Action {
		case delegate(Delegate)
		
		@CasePathable
		enum Delegate {
			case connectButtonTapped
		}
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .delegate:
				return .none
			}
		}
	}
}

// MARK: - View

struct PokemonView: View {
	let store: StoreOf<PokemonItemReducer>

	var body: some View {
		VStack(spacing: 24) {
			Circle()
				.fill(Color(.systemGray6))
				.overlay {
					WebImage(url: store.pokemon.imageUrl) { image in
						image
							.resizable()
							.scaleEffect(.init(width: 0.8, height: 0.8), anchor: .bottom)
					} placeholder: {
						Image(.shadow)
							.resizable()
							.scaleEffect(.init(width: 0.7, height: 0.7), anchor: .bottom)
					}
				}
				.padding(.horizontal, 28)
				.padding(.top, 16)

			Text(store.pokemon.name)
				.font(.system(size: 16))

			Button(action: {
				store.send(.delegate(.connectButtonTapped))
			}, label: {
				Text(store.pokemon.isConnected ? "Connected" : "Connect")
			})
			.buttonStyle(.main)
			.padding(.bottom, 16)
		}
		.frame(maxWidth: .infinity)
		.frame(maxHeight: .infinity, alignment: .top)
		.background {
			RoundedRectangle(cornerRadius: 6)
				.fill(.quaternary)
		}
	}
}

// MARK: - Previews

#Preview(traits: .sizeThatFitsLayout) {
	PokemonView(
		store: Store(
			initialState: .init(pokemon: .bulbasaur)) {
		PokemonItemReducer()
	})
}

#Preview("Loading", traits: .sizeThatFitsLayout) {
	return PokemonView(
		store: Store(
			initialState: .init(pokemon: .pidgeottoWithoutImage)) {
		PokemonItemReducer()
	})
}
