//
//  Event.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import SwiftUI

struct Event: Identifiable, Equatable {
	let id = UUID()
	/// Here should be URL for remote resource
	let image: ImageResource
	let title: String
	let location: String
	let date: Date
	let pokemonIds: Set<Int32>
}

@dynamicMemberLookup
struct FeaturedEvent: Equatable {
	let featuredTitle: String
	let event: Event

	subscript<T>(dynamicMember keyPath: KeyPath<Event, T>) -> T {
		event[keyPath: keyPath]
	}
}

extension Event {
	var dateString: String {
		DateFormatter.event.string(from: date)
	}
}

extension FeaturedEvent {
	static let featured = Self(featuredTitle: "Popular in Kanto",
							   event: .init(image: .featured,
											title: "The Dream Continues!",
											location: "Pallet Town",
											date: .from(string: "04.10.2024"),
											pokemonIds: [1, 5, 12, 18, 22, 31]))
}

extension Event {
	static let event1 = Self(image: .event01,
							 title: "Legends? Go! Friends? Go!",
							 location: "Cinnabar Island",
							 date: .from(string: "18.10.2024"),
							 pokemonIds: [2, 6, 11, 21, 39, 112])

	static let event2 = Self(image: .event02,
							 title: "EXHALE with Professor Oak",
							 location: "Pallet Town",
							 date: .from(string: "22.10.2024"),
							 pokemonIds: [4, 8, 126, 54, 87, 224])

	static let event3 = Self(image: .event03,
							 title: "The Dream Continues!",
							 location: "Cinnabar Island",
							 date: .from(string: "24.10.2024"),
							 pokemonIds: [346, 72, 142, 265, 44, 444])
}
