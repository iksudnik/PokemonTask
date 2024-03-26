//
//  PokemonEntity.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import Foundation

extension PokemonEntity {
	func toPokemon() -> Pokemon {
		.init(id: Int(id), name: name ?? "", isConnected: isConnected)
	}

	func update(from pokemon: Pokemon) {
		id = Int32(pokemon.id)
		name = pokemon.name
		isConnected = pokemon.isConnected
	}
}
