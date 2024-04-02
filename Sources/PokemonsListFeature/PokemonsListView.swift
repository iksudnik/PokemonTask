import ComposableArchitecture
import Mocks
import Models
import SwiftUI
import SwiftUIHelpers

public struct PokemonsListView: View {
	let store: StoreOf<PokemonsListFeature>
	let contentHorizontalPadding: CGFloat

	public init(store: StoreOf<PokemonsListFeature>,
				contentHorizontalPadding: CGFloat = 12) {
		self.store = store
		self.contentHorizontalPadding = contentHorizontalPadding
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
					.asButton() {
						store.send(.delegate(.pokemonTapped(pokemon)))
					}
					.containerRelativeFrame(.horizontal,
											count: 5,
											span: 2,
											spacing: spacing)
				}
			}
			.padding(.horizontal, contentHorizontalPadding)
		}
		.scrollIndicators(.never)
	}
}


// MARK: - Previews

#Preview(traits: .sizeThatFitsLayout) {
	return PokemonsListView(
		store: Store(
			initialState: PokemonsListFeature.State(
				pokemons: .init(uniqueElements: HomeResponse.mock.popularPokemons))) {
				PokemonsListFeature()
			}
	)
	.frame(height: 260)
}
