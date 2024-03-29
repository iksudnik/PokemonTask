//
//  PokemonEntity.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import Foundation

extension PokemonEntity {
	func toPokemon() -> Pokemon {
		.init(id: id, name: name ?? "", height: height, weight: weight,
			  order: order, imageUrl: imageUrl, isConnected: isConnected)
	}

	func update(from pokemon: Pokemon) {
		id = Int32(pokemon.id)
		name = pokemon.name
		height = pokemon.height
		weight = pokemon.weight
		order = pokemon.order
		imageUrl = pokemon.imageUrl
		isConnected = pokemon.isConnected
	}
}
