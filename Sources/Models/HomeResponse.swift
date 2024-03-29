import Foundation

public struct HomeResponse {
	public let featuredEvent: FeaturedEvent
	public let weaklyEvents: [Event]
	public let popularPokemons: [Pokemon]

	public init(featuredEvent: FeaturedEvent, weaklyEvents: [Event], popularPokemons: [Pokemon]) {
		self.featuredEvent = featuredEvent
		self.weaklyEvents = weaklyEvents
		self.popularPokemons = popularPokemons
	}
}
