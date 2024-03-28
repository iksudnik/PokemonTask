//
//  PokemonsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

struct PokemonsListView: View {
	var store: StoreOf<PokemonsListFeature>

	private let spacing: CGFloat = 8

	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: spacing) {
				ForEach(store.scope(state: \.pokemons, action: \.pokemons)) { pokemon in
					PokemonItemView(store: pokemon)
						.containerRelativeFrame(.horizontal,
												count: 5,
												span: 2,
												spacing: spacing)
						.onTapGesture {
							store.send(.delegate(.pokemonTapped(pokemon.pokemon)))
						}
				}
			}
		}
		.scrollIndicators(.never)
	}
}

// MARK: - Previews

#Preview(traits: .sizeThatFitsLayout) {
	return PokemonsListView(
		store: Store(
			initialState: PokemonsListFeature.State()) {
				PokemonsListFeature()
			}
	)
	.frame(height: 260)
}
