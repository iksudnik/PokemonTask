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
	static var featured: Self {
		.init(featuredTitle: "Popular in Kanto",
			  event: .init(image: .featured,
						   title: "The Dream Continues!",
						   location: "Pallet Town",
						   date: .from(string: "04.10.2024")))
	}
}

extension Event {
	static var event1: Self {
		.init(image: .event01,
			  title: "Legends? Go! Friends? Go!",
			  location: "Cinnabar Island",
			  date: .from(string: "18.10.2024"))
	}

	static var event2: Self {
		.init(image: .event02,
			  title: "EXHALE with Professor Oak",
			  location: "Pallet Town",
			  date: .from(string: "22.10.2024"))
	}

	static var event3: Self {
		.init(image: .event03,
			  title: "The Dream Continues!",
			  location: "Cinnabar Island",
			  date: .from(string: "24.10.2024"))
	}
}
