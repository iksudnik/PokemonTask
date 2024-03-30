import ComposableArchitecture
import SwiftUI
import SwiftUIHelpers

public struct PokemonsListView: View {
	let store: StoreOf<PokemonsListFeature>

	public init(store: StoreOf<PokemonsListFeature>) {
		self.store = store
	}

	private let spacing: CGFloat = 8

	public var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: spacing) {
				ForEach(store.pokemons) { pokemon in
					PokemonItemView(pokemon: pokemon,
									onConnectButtonTap: {
						store.send(.pokemonConnectButtonTapped(pokemon))
					})
					.onTapGesture {
						store.send(.delegate(.pokemonTapped(pokemon)))
					}
					.containerRelativeFrame(.horizontal,
											count: 5,
											span: 2,
											spacing: spacing)
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
