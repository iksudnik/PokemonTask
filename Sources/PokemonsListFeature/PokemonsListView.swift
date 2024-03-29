import ComposableArchitecture
import SwiftUI
import PokemonItemFeature

public struct PokemonsListView: View {
	let store: StoreOf<PokemonsListFeature>

	public init(store: StoreOf<PokemonsListFeature>) {
		self.store = store
	}

	private let spacing: CGFloat = 8

	public var body: some View {
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
