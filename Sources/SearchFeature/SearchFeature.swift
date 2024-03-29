import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
public struct SearchFeature {
	public struct State: Equatable {
		public init() {}
	}

	public init() {}
}

// MARK: - View

public struct SearchView: View {
	let store: StoreOf<SearchFeature>

	public init(store: StoreOf<SearchFeature>) {
		self.store = store
	}

	public var body: some View {
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
