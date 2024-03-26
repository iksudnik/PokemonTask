//
//  PokemonDetailsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import ComposableArchitecture
import SDWebImageSwiftUI
import SwiftUI

@Reducer
struct PokemonDetailsReducer {

	@ObservableState
	struct State: Equatable {
		var pokemon: Pokemon
	}

	enum Action {
		case connectButtonTapped
		case updateIsConnected(Bool)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .connectButtonTapped:
				return .run { [pokemon = state.pokemon] send in
					let isConnected = !pokemon.isConnected
					try await repository.updatePokemonIsConnected(isConnected, pokemon.id)
					await send(.updateIsConnected(isConnected), animation: .smooth)
				}

			case let .updateIsConnected(isConnected):
				state.pokemon.isConnected = isConnected
				return .none
			}
		}
	}
}

// MARK: - View

struct PokemonDetailsView: View {
	let store: StoreOf<PokemonDetailsReducer>
	var body: some View {
		ScrollView {
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
					.containerRelativeFrame(.horizontal) { width, _ in
						width * 0.6
					}
					.padding(.top, 16)

				VStack(alignment: .leading, spacing: 32) {
					Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {

						GridRow() {
							Text("Name:")
								.fontWeight(.semibold)
								.gridColumnAlignment(.trailing)
							Text(store.pokemon.name)
						}

						GridRow {
							Text("Height:")
								.fontWeight(.semibold)
							Text("\(store.pokemon.height)")
						}

						GridRow {
							Text("Weight:")
								.fontWeight(.semibold)
							Text("\(store.pokemon.weight)")
						}
					}
					.font(.system(size: 16))

					Button(action: {
						store.send(.connectButtonTapped)
					}, label: {
						Text(store.pokemon.isConnected ? "Connected" : "Connect")
							.frame(maxWidth: .infinity)
					})
					.buttonStyle(.main)
				}
				.padding(.top, 8)
				.padding(.horizontal, 16)
			}
		}
		.navigationTitle(store.pokemon.name)
	}
}

private extension Pokemon {
	var info: [String : String] {
		return [ "Name" : name,
				 "Height" : "\(height)",
				 "Weight" : "\(weight)"
		]
	}
}


// MARK: - Previews

#Preview {
	PokemonDetailsView(store: Store(
		initialState: PokemonDetailsReducer.State(pokemon: .bulbasaur)) {
			PokemonDetailsReducer()
		}
	)
}
