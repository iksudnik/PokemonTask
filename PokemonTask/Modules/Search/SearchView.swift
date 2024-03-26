//
//  SearchView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
struct SearchReducer {
	struct State: Equatable {}
}

// MARK: - View

struct SearchView: View {
	let store: StoreOf<SearchReducer>
    var body: some View {
        Text("Search")
    }
}

// MARK: - Previews

#Preview {
	SearchView(store: Store(
		initialState: SearchReducer.State()) {
			SearchReducer()
		}
	)
}
