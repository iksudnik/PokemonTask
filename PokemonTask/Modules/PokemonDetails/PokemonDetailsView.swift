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
		var connectButton: PokemonConnectButtonFeature.State

		init(pokemon: Pokemon) {
			self.pokemon = pokemon
			connectButton = .init(pokemon: pokemon)
		}
	}

	enum Action {
		case connectButton(PokemonConnectButtonFeature.Action)
	}

	var body: some ReducerOf<Self> {
		
		Scope(state: \.connectButton, action: \.connectButton) {
			PokemonConnectButtonFeature()
		}

		Reduce { state, action in
			switch action {
			case .connectButton:
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

					PokemonConnectButton(store: store.scope(state: \.connectButton, action: \.connectButton))
						.buttonStyle(.main)
				}
				.padding(.top, 8)
				.padding(.horizontal, 16)
			}
		}
		.navigationTitle(store.pokemon.name)
		.toolbar(.hidden, for: .tabBar)
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
