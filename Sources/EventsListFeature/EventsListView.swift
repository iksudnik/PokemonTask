import ComposableArchitecture
import SwiftUI
import SwiftUIHelpers

public struct EventsListView: View {
	var store: StoreOf<EventsListFeature>

	private let spacing: CGFloat = 8

	public init(store: StoreOf<EventsListFeature>) {
		self.store = store
	}

	public var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: spacing) {
				ForEach(store.events) { event in
					EventItemView(event: event)
						.onTapGesture {
							store.send(.delegate(.eventTapped(event)))
						}
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

