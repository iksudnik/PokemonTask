//
//  ApiClient.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct ApiClient {
	var pokemon: (_ id: Int32) async throws -> Pokemon
}

extension ApiClient: DependencyKey {
	private static func pokemonUrl(for id: Int32) -> URL {
		URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
	}

	static let liveValue = Self(
		pokemon: { id in
			let url = pokemonUrl(for: id)
			let (data, _) = try await URLSession.shared.data(from: url)
			return try JSONDecoder().decode(Pokemon.self, from: data)
		}
	)
}

extension ApiClient: TestDependencyKey {
	static let previewValue = Self(
		pokemon: { _ in .bulbasaur }
	)

	static let testValue = Self()
}

extension DependencyValues {
	var apiClient: ApiClient {
		get { self[ApiClient.self] }
		set { self[ApiClient.self] = newValue }
	}
}

