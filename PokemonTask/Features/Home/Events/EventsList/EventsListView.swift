//
//  EventsListView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

struct EventsListView: View {
	var store: StoreOf<EventsListFeature>

	private let spacing: CGFloat = 8

	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: spacing) {
				ForEach(store.scope(state: \.events, action: \.events)) { event in
					EventItemView(store: event)
						.containerRelativeFrame(.horizontal,
												count: 21,
												span: 10,
												spacing: spacing)
				}
			}
		}
		.scrollIndicators(.never)
	}
}

// MARK: - Previews

#Preview {
	EventsListView(
		store: Store(initialState: EventsListFeature.State()) {
			EventsListFeature()
		}
	)
}

