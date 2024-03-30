import ComposableArchitecture
import SwiftUI
import SwiftUIHelpers

public struct PokemonDetailsView: View {
	let store: StoreOf<PokemonDetailsFeature>

	public init(store: StoreOf<PokemonDetailsFeature>) {
		self.store = store
	}

	public var body: some View {
		ScrollView {
			VStack(spacing: 24) {
				PokemonImageView(imageUrl: store.pokemon.imageUrl)
					.containerRelativeFrame(.horizontal) { width, _ in
						width * 0.6
					}
					.padding(.top, 16)

				VStack(spacing: 32) {

					GroupBox("Details:") {
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
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.top)
						.font(.system(size: 16))
					}

					ConnectButton(isConnected: store.pokemon.isConnected) {
						store.send(.connectButtonTapped)
					}
				}
				.padding(.top, 8)
				.padding(.horizontal, 16)
			}
		}
		.navigationTitle(store.pokemon.name)
		.toolbar(.hidden, for: .tabBar)
	}
}


// MARK: - Previews

#Preview {
	PokemonDetailsView(store: Store(
		initialState: PokemonDetailsFeature.State(pokemon: .bulbasaur)) {
			PokemonDetailsFeature()
		}
	)
}
