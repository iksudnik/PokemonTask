//
//  EventsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct EventsListReducer {
	@ObservableState
	struct State: Equatable {
		var events: IdentifiedArrayOf<EventItemReducer.State> = []
	}

	enum Action {
		case events(IdentifiedActionOf<EventItemReducer>)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .events:
				return .none
			}
		}
	}
}

// MARK: - View

struct EventsView: View {
	var store: StoreOf<EventsListReducer>

	private let spacing: CGFloat = 8

	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: spacing) {
				ForEach(store.scope(state: \.events, action: \.events)) { event in
					EventView(store: event)
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
	EventsView(
		store: Store(initialState: EventsListReducer.State()) {
			EventsListReducer()
		}
	)
}

