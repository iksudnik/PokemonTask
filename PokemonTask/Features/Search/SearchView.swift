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
struct SearchFeature {
	struct State: Equatable {}
}

// MARK: - View

struct SearchView: View {
	let store: StoreOf<SearchFeature>
    var body: some View {
        Text("Search")
    }
}

// MARK: - Previews

#Preview {
	SearchView(store: Store(
		initialState: SearchFeature.State()) {
			SearchFeature()
		}
	)
}
