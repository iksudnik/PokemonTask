//
//  HomeTopBarView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import ComposableArchitecture
import SwiftUI

struct HomeTopBarView: View {
	let store: StoreOf<HomeTopBarFeature>

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
		initialState: HomeTopBarFeature.State()) {
			HomeTopBarFeature()
		})
}
