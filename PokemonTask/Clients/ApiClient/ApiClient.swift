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
	var fetchPokemons: (PokemonsFetchType) async throws -> PokemonResponse
}

enum PokemonsFetchType {
	case initial(_ limit: Int = 20, offset: Int = 0)
	case next(_ nextUrl: URL)

	var url: URL {
		switch self {
		case let .initial(limit, offset):
			return URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=\(limit)")!
		case let .next(url):
			return url
		}
	}
}

extension ApiClient: DependencyKey {
	static let liveValue = Self(
		fetchPokemons: { fetchType in
			let url = fetchType.url
			let (data, _) = try await URLSession.shared.data(from: url)
			return try JSONDecoder().decode(PokemonResponse.self, from: data)
		}
	)
}

extension ApiClient: TestDependencyKey {
	static let previewValue = Self(
		fetchPokemons: { _ in .mock }
	)

	static let testValue = Self()
}

extension DependencyValues {
	var apiClient: ApiClient {
		get { self[ApiClient.self] }
		set { self[ApiClient.self] = newValue }
	}
}

