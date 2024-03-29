import Foundation

public struct EventsResponse {
	public let featuredEvent: FeaturedEvent
	public let weaklyEvents: [Event]

	public init(featuredEvent: FeaturedEvent, weaklyEvents: [Event]) {
		self.featuredEvent = featuredEvent
		self.weaklyEvents = weaklyEvents
	}
}

public extension EventsResponse {
	var allEvents: [Event] {
		weaklyEvents + [featuredEvent.event]
	}

	var allPokemonIDs: Set<Pokemon.ID> {
		return Set(allEvents.flatMap { $0.pokemonIds })
	}
}
