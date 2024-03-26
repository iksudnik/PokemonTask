//
//  HomeTopBarView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct HomeTopBarReducer {
	@ObservableState
	struct State: Equatable {
		var isLoggedIn = false
	}

	enum Action {
		case delegate(Delegate)

		@CasePathable
		enum Delegate {
			case loginButtonTapped
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

struct HomeTopBarView: View {
	let store: StoreOf<HomeTopBarReducer>

	var body: some View {
		HStack {
			HStack(spacing: 8) {
				Image(systemName: "map")

				Text("Kanto")
					.font(.system(size: 20, weight: .semibold))
					.padding(.bottom, 4)
					.overlay(
						Rectangle()
							.frame(height: 2)
							.foregroundColor(.primary),
						alignment: .bottom
					)
			}
			.font(.system(size: 24))
			Spacer()
			if store.isLoggedIn {
				Circle()
			} else {
				Button(action: {
					store.send(.delegate(.loginButtonTapped))
				}, label: {
					Text("Sign In or Register")
				})
				.buttonStyle(.main)
			}
		}
	}
}

#Preview {
	HomeTopBarView(store: Store(
		initialState: HomeTopBarReducer.State()) {
			HomeTopBarReducer()
		})
}
