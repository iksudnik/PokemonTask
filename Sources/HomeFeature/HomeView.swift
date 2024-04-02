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

	private let sideOffset: CGFloat = 12

	public var body: some View {

		NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
			VStack {
				Group {
					if store.loadingState == .idle {
						HomeTopBarView(store: Store(
							initialState: .init()) {
									  EmptyReducer()
								  })
						.redacted(reason: .placeholder)
					} else {
						HomeTopBarView(store: store.scope(state: \.topBar,
														  action: \.topBar))
						.zIndex(1)
					}
				}
				.padding(.bottom, 16)
				.padding(.horizontal, sideOffset)

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
							.padding(.horizontal, sideOffset)
							.redacted(reason: .placeholder)
						} else {
							if let store = store.scope(state: \.featuredEvent, action: \.featuredEvent) {
								FeaturedEventView(store: store)
									.padding(.horizontal, sideOffset)
							}

							if let store = store.scope(state: \.events, action: \.events) {
								SectionView(title: "This Weak",
											titleOffset: sideOffset) {
									EventsListView(store: store,
												   contentHorizontalPadding: sideOffset)
								}
							}

							if let store = store.scope(state: \.pokemons, action: \.pokemons) {
								SectionView(title: "Popular Pokemons",
											titleOffset: sideOffset) {
									PokemonsListView(store: store,
													 contentHorizontalPadding: sideOffset)
								}
							}
						}
					}
					.padding(.bottom, 32)
				}
				.scrollIndicators(.never)
			}
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

#Preview("Loading") {
	HomeView(
		store: Store(
			initialState: HomeFeature.State()
		) {
			EmptyReducer()
		}
	)
}
