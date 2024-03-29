import Foundation
import Models

public extension HomeResponse {
	static let mock = Self(featuredEvent: EventsResponse.mock.featuredEvent,
						   weaklyEvents: EventsResponse.mock.weaklyEvents,
						   popularPokemons: [.bulbasaur, .charizard, .pidgeotto])
}


public extension EventsResponse {
	static let mock = Self(featuredEvent: .featured,
						   weaklyEvents: [.event1, .event2, .event3])
}
