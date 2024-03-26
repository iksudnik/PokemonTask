//
//  FeaturedEventView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct FeaturedEventReducer {
	@ObservableState
	struct State: Equatable {
		var event: FeaturedEvent
	}

	enum Action {
		case delegate(Delegate)

		@CasePathable
		enum Delegate {
			case eventTapped(Event)
		}
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .delegate:
				return .none
			}
		}
	}
}

// MARK: - View

struct FeaturedEventView: View {
	let store: StoreOf<FeaturedEventReducer>

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
				Text(store.event.featuredTitle)
					.foregroundStyle(.accent)
					.font(.system(size: 18))
				Text(store.event.title)
					.font(.system(size: 24))
				HStack(spacing: 16) {
					Text(store.event.dateString)
					Text(store.event.location)
				}
				.font(.system(size: 16))
				.foregroundStyle(.secondary)
			}
		}
		.onTapGesture {
			store.send(.delegate(.eventTapped(store.event.event)))
		}
	}
}

// MARK: - Previews

#Preview {
	FeaturedEventView(
		store: Store(
			initialState: .init(event: .featured)) {
				FeaturedEventReducer()
		})
}

