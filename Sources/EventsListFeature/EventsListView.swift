import ComposableArchitecture
import EventItemFeature
import SwiftUI

public struct EventsListView: View {
	var store: StoreOf<EventsListFeature>

	private let spacing: CGFloat = 8

	public init(store: StoreOf<EventsListFeature>) {
		self.store = store
	}

	public var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: spacing) {
				ForEach(store.scope(state: \.events, action: \.events)) { event in
					EventItemView(store: event)
						.containerRelativeFrame(.horizontal,
												count: 21,
												span: 10,
												spacing: spacing)
				}
			}
		}
		.scrollIndicators(.never)
	}
}

// MARK: - Previews

#Preview {
	EventsListView(
		store: Store(initialState: EventsListFeature.State()) {
			EventsListFeature()
		}
	)
}

