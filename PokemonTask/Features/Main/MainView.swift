//
//  MainView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
	@Bindable var store: StoreOf<MainFeature>

	var body: some View {
		TabView {
			HomeView(store: store.scope(state: \.homeTab, action: \.homeTab))
				.tabItem { Label("HOME", systemImage: "house") }

			SearchView(store: store.scope(state: \.searchTab, action: \.searchTab))
				.tabItem { Label("SEARCH", systemImage: "magnifyingglass")}
			
			TicketsView(store: store.scope(state: \.ticketsTab, action: \.ticketsTab))
				.tabItem { Label("TICKETS", systemImage: "ticket")}
		}
		.tint(.accent)
	}
}

#Preview {
	MainView(store: Store(
		initialState: MainFeature.State()) {
			MainFeature()
		}
	)
}
