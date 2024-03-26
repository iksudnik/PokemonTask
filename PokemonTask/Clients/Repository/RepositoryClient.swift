//
//  RepositoryClient.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct Repository {
	var pokemons: (PokemonsFetchType) async throws -> PokemonResponse
	var updatePokemonIsConnected: (_ isConnected: Bool, _ id: Int) async throws -> Void
	var featuredEvent: () async throws -> FeaturedEvent
	var weaklyEvents: () async throws -> [Event]
}

extension Repository: DependencyKey {
	static let liveValue = {
		@Dependency(\.apiClient) var apiClient
		@Dependency(\.databaseClient) var database

		return Self(
			pokemons: { fetchType in
				
				if case .initial = fetchType {
					let storedPokemons = try await database.pokemones()
					if !storedPokemons.results.isEmpty {
						return storedPokemons
					}
				}

				let response = try await apiClient.fetchPokemons(fetchType)
				try await database.savePokemons(response)
				return response
			},
			updatePokemonIsConnected: { isConnected, id in
				try await database.updatePokemonIsConnected(isConnected, id)
			},
			/// Here should be some logic to get events
			/// But I'm using just mocked data
			/// And sleep to simulate loading
			featuredEvent: {
				try await Task.sleep(for: .seconds(2))
				return .featured
			},
			weaklyEvents: {
				try await Task.sleep(for: .seconds(2))
				return [.event1, .event2, .event3]
			}
		)
	}()
}

extension Repository: TestDependencyKey {
	static let previewValue = Self(
		pokemons: { _ in .mock },
		updatePokemonIsConnected: { _,_  in },
		featuredEvent: { .featured },
		weaklyEvents: { [.event1, .event2, .event3] }
	)

	static let testValue = Self()
}

extension DependencyValues {
	var repository: Repository {
		get { self[Repository.self] }
		set { self[Repository.self] = newValue }
	}
}

