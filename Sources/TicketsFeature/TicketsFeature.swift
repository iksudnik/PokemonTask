import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
public struct TicketsFeature {
	public struct State: Equatable {
		public init() {}
	}

	public init() {}
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
