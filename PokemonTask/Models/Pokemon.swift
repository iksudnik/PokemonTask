//
//  Pokemon.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import Foundation

struct Pokemon: Decodable, Identifiable, Equatable {
	let id: Int
	let name: String
	var isConnected: Bool

	enum CodingKeys: String, CodingKey {
		case name
		case url
	}

	init(id: Int, name: String, isConnected: Bool) {
		self.id = id
		self.name = name
		self.isConnected = isConnected
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		let name = try container.decode(String.self, forKey: .name)
		self.name = name.prefix(1).capitalized + name.dropFirst()

		let urlString = try container.decode(String.self, forKey: .url)
		if let url = URL(string: urlString),
		   let lastSegment = url.pathComponents.last,
		   let extractedId = Int(lastSegment) {
			id = extractedId
		} else {
			throw DecodingError.dataCorruptedError(forKey: .url,
												   in: container,
												   debugDescription: "ID could not be extracted from URL")
		}

		self.isConnected = false
	}
}

/// I've decided to get image url such way
/// Because it's look wird for me to make for every pokemon extra request to get same url
extension Pokemon {
	var imageUrl: URL? {
		URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
	}
}

extension Pokemon {
	static var bulbasaur: Self {
		.init(id: 1, name: "Bulbasaur", isConnected: false)
	}

	static var charizard: Self {
		.init(id: 6, name: "Сharizard", isConnected: true)
	}

	static var pidgeotto: Self {
		.init(id: 17, name: "Pidgeotto", isConnected: false)
	}
}
