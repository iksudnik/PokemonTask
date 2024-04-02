import ComposableArchitecture
import Mocks
import Models
import SwiftUI
import SwiftUIHelpers

public struct EventsListView: View {
	var store: StoreOf<EventsListFeature>
	let contentHorizontalPadding: CGFloat

	private let spacing: CGFloat = 8

	public init(store: StoreOf<EventsListFeature>,
				contentHorizontalPadding: CGFloat = 12) {
		self.store = store
		self.contentHorizontalPadding = contentHorizontalPadding
	}

	public var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(alignment: .top, spacing: spacing) {
				ForEach(store.events) { event in
					EventItemView(event: event)
						.asButton() {
							store.send(.delegate(.eventTapped(event)))
						}
						.containerRelativeFrame(.horizontal,
												count: 11,
												span: 5,
												spacing: spacing)
				}
			}
			.padding(.horizontal, contentHorizontalPadding)
		}
		.scrollIndicators(.never)
	}
}

// MARK: - Previews

#Preview {
	EventsListView(
		store: Store(initialState: EventsListFeature.State(events: .init(uniqueElements: HomeResponse.mock.weaklyEvents))) {
			EventsListFeature()
		}
	)
}

