import ComposableArchitecture
import FeaturedEventFeature
import HomeTopBarFeature
import EventDetailsFeature
import EventsListFeature
import SwiftUI
import SwiftUIHelpers
import PokemonDetailsFeature
import PokemonsListFeature

public struct HomeView: View {
	@Bindable public var store: StoreOf<HomeFeature>

	public init(store: StoreOf<HomeFeature>) {
		self.store = store
	}

	public var body: some View {

		NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
			VStack {
				HomeTopBarView(store: store.scope(state: \.topBar,
												  action: \.topBar))
				.padding(.bottom, 16)

				ScrollView {
					VStack(spacing: 32) {
						if store.loadingState == .idle {
							Group {
								FeaturedEventView(store: Store(
									initialState: .init(event: .featured)) {
										EmptyReducer()
									})

								SectionView(title: "This Weak") {
									EventsListView(store: Store(
										initialState: .init()) {
											EmptyReducer()
										})
								}

								SectionView(title: "Popular Pokemons") {
									PokemonsListView(store: Store(
										initialState: PokemonsListFeature.State()) {
											EmptyReducer()
										})
								}
							}
							.redacted(reason: .placeholder)
						} else {
							if let store = store.scope(state: \.featuredEvent, action: \.featuredEvent) {
								FeaturedEventView(store: store)
							}

							if let store = store.scope(state: \.events, action: \.events) {
								SectionView(title: "This Weak") {
									EventsListView(store: store)
								}
							}

							if let store = store.scope(state: \.pokemons, action: \.pokemons) {
								SectionView(title: "Popular Pokemons") {
									PokemonsListView(store: store)
								}
							}
						}
					}
					.padding(.bottom, 32)
				}
				.scrollIndicators(.never)
			}
			.padding(.horizontal, 12)
			.background(Color(.systemGray6))
			.task {
				store.send(.onTask)
			}
		} destination: { store in
			switch store.case {
			case let .eventDetails(store):
				EventDetailsView(store: store)
			case let .pokemonDetails(store):
				PokemonDetailsView(store: store)
			}
		}

	}
}

// MARK: - Previews

#Preview {
	HomeView(
		store: Store(
			initialState: HomeFeature.State()
		) {
			HomeFeature()
		}
	)
}
