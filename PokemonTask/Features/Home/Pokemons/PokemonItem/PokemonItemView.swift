//
//  PokemonItemView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//
import ComposableArchitecture
import SwiftUI

struct PokemonItemView: View {
	let store: StoreOf<PokemonItemFeature>

	var body: some View {
		VStack(spacing: 24) {
			PokemonImageView(imageUrl: store.pokemon.imageUrl)
				.padding(.horizontal, 28)
				.padding(.top, 16)

			Text(store.pokemon.name)
				.font(.system(size: 16))

			PokemonConnectButton(store: store.scope(state: \.connectButton, action: \.connectButton))
			.padding(.bottom, 16)
			.padding(.horizontal, 8)
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
	PokemonItemView(
		store: Store(
			initialState: .init(pokemon: .bulbasaur)) {
		PokemonItemFeature()
	})
}

#Preview("Loading", traits: .sizeThatFitsLayout) {
	return PokemonItemView(
		store: Store(
			initialState: .init(pokemon: .pidgeottoWithoutImage)) {
		PokemonItemFeature()
	})
}
