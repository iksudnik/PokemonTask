//
//  TicketsView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct TicketsReducer {
	struct State: Equatable {}
}

// MARK: - View

struct TicketsView: View {
	let store: StoreOf<TicketsReducer>
	var body: some View {
		Text("Tickets")
	}
}

// MARK: - Previews

#Preview {
	TicketsView(store: Store(
		initialState: TicketsReducer.State()) {
			TicketsReducer()
		}
	)
}
