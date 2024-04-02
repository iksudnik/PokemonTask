import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
public struct TicketsFeature: Sendable {
	public struct State: Equatable {
		public init() {}
	}

	public enum Action: Sendable {}

	public init() {}

	public var body: some ReducerOf<Self> {
		EmptyReducer()
	}
}

// MARK: - View

public struct TicketsView: View {
	let store: StoreOf<TicketsFeature>

	public init(store: StoreOf<TicketsFeature>) {
		self.store = store
	}

	public var body: some View {
		Text("Tickets")
	}
}

// MARK: - Previews

#Preview {
	TicketsView(store: Store(
		initialState: TicketsFeature.State()) {
			TicketsFeature()
		}
	)
}
