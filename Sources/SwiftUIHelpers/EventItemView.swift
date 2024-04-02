import SwiftUI
import Models
import Mocks

public struct EventItemView: View {
	var event: Event

	public init(event: Event) {
		self.event = event
	}

	public var body: some View {
		VStack(alignment: .leading) {
			Color.secondary
				.aspectRatio(1, contentMode: .fit)
				.overlay {
					Image(event.image)
						.resizable()
						.scaledToFill()
						.clipped()

				}
				.cornerRadius(8)

			VStack(alignment: .leading, spacing: 4) {
				Text(event.title)
					.font(.system(size: 16))
					.multilineTextAlignment(.leading)
				Group {
					Text(event.dateString)
					Text(event.location)
				}
				.font(.system(size: 16))
				.foregroundStyle(.secondary)
			}
			.padding(.vertical, 8)
		}
		.contentShape(Rectangle())
	}
}

// MARK: - Previews

#Preview {
	EventItemView(event: .event1)
		.asButton() {}
		.frame(width: 200)
}

