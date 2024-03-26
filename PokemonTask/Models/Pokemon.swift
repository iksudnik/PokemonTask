//
//  Pokemon.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import Foundation

struct Pokemon: Decodable, Identifiable, Equatable {
	let id: Int32
	let name: String
	let height: Int32
	let weight: Int32
	let order: Int32
	let imageUrl: URL?
	var isConnected: Bool = false

	enum CodingKeys: String, CodingKey {
		case id, name, height, weight, order, sprites
	}

	enum SpritesCodingKeys: String, CodingKey {
		case other
	}

	enum OtherSpritesCodingKeys: String, CodingKey {
		case officialArtwork = "official-artwork"
	}

	enum OfficialArtworkCodingKeys: String, CodingKey {
		case frontDefault = "front_default"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int32.self, forKey: .id)
		height = try container.decode(Int32.self, forKey: .height)
		weight = try container.decode(Int32.self, forKey: .weight)
		order = try container.decode(Int32.self, forKey: .order)

		let rawName = try container.decode(String.self, forKey: .name)
		self.name = rawName.capitalizingFirstLetter()

		if let spritesContainer = try? container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites),
		   let otherContainer = try? spritesContainer.nestedContainer(keyedBy: OtherSpritesCodingKeys.self, forKey: .other),
		   let officialArtworkContainer = try? otherContainer.nestedContainer(keyedBy: OfficialArtworkCodingKeys.self, forKey: .officialArtwork),
		   let imageUrlString = try? officialArtworkContainer.decode(String.self, forKey: .frontDefault) {
			imageUrl = URL(string: imageUrlString)
		} else {
			imageUrl = nil
		}
	}
}

extension Pokemon {
	init(id: Int32, name: String, height: Int32, weight: Int32,
		 order: Int32, imageUrl: URL? = nil, isConnected: Bool) {
		self.id = id
		self.name = name
		self.height = height
		self.weight = weight
		self.order = order
		self.imageUrl = imageUrl
		self.isConnected = isConnected
	}
}


extension Pokemon {
	static let bulbasaur = Self(id: 1, name: "Bulbasaur", height: 10, weight: 39, 
								order: 1, imageUrl: mockImageUrl(1), isConnected: false)

	static let charizard = Self(id: 6, name: "Bulbasaur", height: 13, weight: 24,
							   order: 2, imageUrl: mockImageUrl(6), isConnected: true)

	static let pidgeotto = Self(id: 17, name: "Pidgeotto", height: 8, weight: 15,
								order: 3, imageUrl: mockImageUrl(17), isConnected: true)

	static let pidgeottoWithoutImage = Self(id: 17, name: "Pidgeotto", height: 8, weight: 15, order: 3, isConnected: true)

	private static func mockImageUrl(_ id: Int) -> URL? {
		URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
	}
}

extension [Pokemon] {
	static let mock: Self = [.bulbasaur, .charizard, .pidgeotto]
}
