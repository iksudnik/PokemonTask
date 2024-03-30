import Models
import Mocks
import SwiftUI

public struct PokemonItemView: View {
	var pokemon: Pokemon
	var onConnectButtonTap: () -> Void

	public init(pokemon: Pokemon,
				onConnectButtonTap: @escaping () -> Void) {
		self.pokemon = pokemon
		self.onConnectButtonTap = onConnectButtonTap
	}

	public var body: some View {
		VStack(spacing: 24) {
			PokemonImageView(imageUrl: pokemon.imageUrl)
				.padding(.horizontal, 28)
				.padding(.top, 16)

			Text(pokemon.name)
				.font(.system(size: 16))

			ConnectButton(isConnected: pokemon.isConnected,
						  action: onConnectButtonTap)
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
	PokemonItemView(pokemon: .bulbasaur,
					onConnectButtonTap: {})
}

#Preview("Loading", traits: .sizeThatFitsLayout) {
	return PokemonItemView(pokemon: .pidgeottoWithoutImage,
						   onConnectButtonTap: {})
}
