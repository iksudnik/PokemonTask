import ComposableArchitecture
import SwiftUI
import Mocks

public struct EventItemView: View {
	let store: StoreOf<EventItemFeature>

	public init(store: StoreOf<EventItemFeature>) {
		self.store = store
	}

	public var body: some View {
		VStack(alignment: .leading) {
			Color.secondary
				.aspectRatio(1, contentMode: .fit)
				.overlay {
					Image(store.event.image)
						.resizable()
						.scaledToFill()
				}
				.clipped()
				.cornerRadius(8)

			VStack(alignment: .leading, spacing: 4) {
				Text(store.event.title)
					.font(.system(size: 16))
					.multilineTextAlignment(.leading)
				Group {
					Text(store.event.dateString)
					Text(store.event.location)
				}
				.font(.system(size: 16))
				.foregroundStyle(.secondary)
			}
			.padding(.vertical, 8)
		}
		.frame(maxHeight: .infinity, alignment: .top)
		.onTapGesture {
			store.send(.delegate(.eventTapped(store.event)))
		}
	}
}

// MARK: - Previews

#Preview {
	EventItemView(
		store: Store(
			initialState: EventItemFeature.State(event: .event1)) {
				EventItemFeature()
			}
	)
}

