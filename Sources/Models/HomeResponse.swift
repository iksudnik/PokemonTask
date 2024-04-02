import Foundation

public struct HomeResponse: Sendable {
	public let locations: [Location]
	public let featuredEvent: FeaturedEvent
	public let weaklyEvents: [Event]
	public let popularPokemons: [Pokemon]

	public init(locations: [Location],
				featuredEvent: FeaturedEvent,
				weaklyEvents: [Event],
				popularPokemons: [Pokemon]) {
		self.locations = locations
		self.featuredEvent = featuredEvent
		self.weaklyEvents = weaklyEvents
		self.popularPokemons = popularPokemons
	}
}
