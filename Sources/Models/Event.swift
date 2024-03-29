import SwiftUI

public struct Event: Identifiable, Equatable {
	public let id = UUID()
	/// Here should be URL for remote resource
	public let image: ImageResource
	public let title: String
	public let location: String
	public let date: Date
	public let pokemonIds: Set<Pokemon.ID>

	public init(image: ImageResource, title: String, location: String, date: Date, pokemonIds: Set<Pokemon.ID>) {
		self.image = image
		self.title = title
		self.location = location
		self.date = date
		self.pokemonIds = pokemonIds
	}
}

@dynamicMemberLookup
public struct FeaturedEvent: Equatable {
	public let featuredTitle: String
	public let event: Event

	public init(featuredTitle: String, event: Event) {
		self.featuredTitle = featuredTitle
		self.event = event
	}

	public subscript<T>(dynamicMember keyPath: KeyPath<Event, T>) -> T {
		event[keyPath: keyPath]
	}
}

public extension Event {
	var dateString: String {
		DateFormatter.event.string(from: date)
	}
}
