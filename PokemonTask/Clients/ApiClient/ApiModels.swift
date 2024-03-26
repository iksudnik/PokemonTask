//
//  ApiModels.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import Foundation

struct PokemonResponse: Decodable, Equatable {
	let count: Int
	let next: URL?
	let results: [Pokemon]
}

extension PokemonResponse {
	static var mock: Self {
		.init(count: 3,
			  next: nil,
			  results: [.bulbasaur, .charizard, .pidgeotto])
	}
}
