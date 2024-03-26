//
//  HomeView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct HomeReducer {
	@ObservableState
	struct State: Equatable {
		var topBar = HomeTopBarReducer.State()
		var featuredEvent: FeaturedEventReducer.State?
		var events = EventsListReducer.State()
	}

	enum Action {
		case initialFetch
		case topBar(HomeTopBarReducer.Action)
		case featuredEvent(FeaturedEventReducer.Action)
		case events(EventsListReducer.Action)
		case featuredEventresponse(Result<FeaturedEvent, Error>)
	}

	@Dependency(\.repository) var repository

	var body: some ReducerOf<Self> {

		Reduce { state, action in
			switch action {
			case .initialFetch:
				return .run { send in
					let result = await Result { try await repository.featuredEvent() }
					await send(.featuredEventresponse(result))
				}

			case let .featuredEventresponse(result):
				switch result {
				case let .success(event):
					state.featuredEvent = .init(event: event)
					return .none
				case .failure:
					return .none
				}

			case let .topBar(.delegate(delegateAction)):
				switch delegateAction {
				case .loginButtonTapped:
					return .none
				}

			case .events:
				return .none

			}
		}

		Scope(state: \.topBar, action: \.topBar) {
			HomeTopBarReducer()
		}

		Scope(state: \.events, action: \.events) {
			EventsListReducer()
		}
	}
}

// MARK: - View

struct HomeView: View {
	var store: StoreOf<HomeReducer>

	var body: some View {
		VStack {
			HomeTopBarView(store: store.scope(state: \.topBar,
											  action: \.topBar))
			.padding(.bottom, 16)

			ScrollView {
				VStack(spacing: 32) {
					if let store = store.scope(state: \.featuredEvent, action: \.featuredEvent) {
						FeaturedEventView(store: store)
					} else {
						FeaturedEventView(store: Store(
							initialState: .init(event: .featured)) {
								EmptyReducer()
							})
						.redacted(reason: .placeholder)
					}

					SectionView(title: "This Weak") {
						EventsView(store: store.scope(state: \.events, action: \.events))
					}

					SectionView(title: "Popular Pokemon") {
						PokemonsView(store: Store(
							initialState: PokemonsListReducer.State()) {
								PokemonsListReducer()
							})
					}
				}
				.padding(.bottom, 32)
			}
			.scrollIndicators(.never)
		}
		.padding(.horizontal, 12)
		.background(Color(.systemGray6))
		.task {
			store.send(.initialFetch)
		}
	}
}

// MARK: - Previews

#Preview {
	HomeView(
		store: Store(
			initialState: HomeReducer.State()
		) {
			HomeReducer()
		}
	)
}
