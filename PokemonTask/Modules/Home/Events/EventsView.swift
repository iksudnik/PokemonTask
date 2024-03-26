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
		var isLoading = false
	}

	enum Action {
		case initialFetch
		case eventsResponse(Result<[Event], Error>)
		case events(IdentifiedActionOf<EventItemReducer>)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .initialFetch:
				state.isLoading = true
				return .run { send in
					let result = await Result { try await repository.weaklyEvents() }
					await send(.eventsResponse(result))
				}

			case let .eventsResponse(result):
				state.isLoading = false
				switch result {
				case let .success(events):
					let eventStates: [EventItemReducer.State] = events.map { .init(event: $0) }
					state.events = .init(uniqueElements: eventStates)
					return .none
				case .failure:
					return .none
				}

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
				if store.isLoading {
					let mocked: [Event] = [.event1, .event2, .event3]

					ForEach(mocked) { event in
						EventView(
							store: Store(
								initialState: EventItemReducer.State(event: event)) {
									EmptyReducer()
								}
						)
						.redacted(reason: .placeholder)
						.containerRelativeFrame(.horizontal,
												count: 21,
												span: 10,
												spacing: spacing)
					}
				} else {
					ForEach(store.scope(state: \.events, action: \.events)) { event in
						EventView(store: event)
							.containerRelativeFrame(.horizontal,
													count: 21,
													span: 10,
													spacing: spacing)
					}
				}
			}
		}
		.scrollIndicators(.never)
		.task {
			store.send(.initialFetch)
		}
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

