//
//  EventView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct EventItemReducer {
	@ObservableState
	struct State: Equatable, Identifiable {
		var id: Event.ID { event.id }
		var event: Event
	}
}

// MARK: - View

struct EventView: View {
	let store: StoreOf<EventItemReducer>

	var body: some View {
		VStack(alignment: .leading) {
			Color.secondary
				.aspectRatio(1, contentMode: .fit)
				.overlay {
					Image(store.event.image)
						.resizable()
						.scaledToFill()
				}
				.clipped()
				.cornerRadius(8)

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
			}
			.padding(.vertical, 8)
		}
		.frame(maxHeight: .infinity, alignment: .top)
	}
}

// MARK: - Previews

#Preview {
	EventView(
		store: Store(
			initialState: EventItemReducer.State(event: .event1)) {
				EventItemReducer()
			}
	)
}

