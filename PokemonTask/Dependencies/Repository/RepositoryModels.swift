//
//  EventsResponse.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import Foundation

struct EventsResponse {
	let featuredEvent: FeaturedEvent
	let weaklyEvents: [Event]
}

extension EventsResponse {
	var allEvents: [Event] {
		weaklyEvents + [featuredEvent.event]
	}
	
	var allPokemonIDs: Set<Pokemon.ID> {
		return Set(allEvents.flatMap { $0.pokemonIds })
	}
}

extension EventsResponse {
	static let mock = Self(featuredEvent: .featured,
						   weaklyEvents: [.event1, .event2, .event3])
}


struct HomeResponse {
	let featuredEvent: FeaturedEvent
	let weaklyEvents: [Event]
	let popularPokemons: [Pokemon]
}

extension HomeResponse {
	static let mock = Self(featuredEvent: EventsResponse.mock.featuredEvent,
						   weaklyEvents: EventsResponse.mock.weaklyEvents,
						   popularPokemons: [.bulbasaur, .charizard, .pidgeotto])
}
