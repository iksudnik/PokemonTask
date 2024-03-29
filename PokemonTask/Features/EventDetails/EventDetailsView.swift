//
//  EventDetailsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import ComposableArchitecture
import SwiftUI

struct EventDetailsView: View {
	let store: StoreOf<EventDetailsFeature>
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Color.secondary
					.aspectRatio(1, contentMode: .fit)
					.overlay {
						Image(store.event.image)
							.resizable()
							.scaledToFill()
					}
					.clipped()

				VStack(alignment: .leading, spacing: 4) {
					Text(store.event.title)
						.font(.system(size: 16))
						.multilineTextAlignment(.leading)
					Group {
						Text(store.event.dateString)
						Text(store.event.location)
					}
					.font(.system(size: 16))
					.foregroundStyle(.secondary)

					if let store = store.scope(state: \.pokemons, action: \.pokemons) {
						SectionView(title: "Featured Pokemons") {
							PokemonsListView(store: store)
						}
						.padding(.top, 16)
					}
				}
				.padding(.horizontal, 16)
			}
		}
		.ignoresSafeArea(edges: .top)
		.navigationTitle(store.event.title)
		.scrollIndicators(.hidden)
		.toolbar(.hidden, for: .tabBar)
		.task {
			store.send(.onAppear)
		}
	}
}

// MARK: - Previews

#Preview {
	EventDetailsView(store: Store(
		initialState: EventDetailsFeature.State(event: .event1)) {
			EventDetailsFeature()
		}
	)
}
