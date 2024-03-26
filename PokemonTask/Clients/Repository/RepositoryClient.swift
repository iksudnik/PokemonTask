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
	var homeData: () async throws -> HomeResponse
	var pokemons: (Set<Pokemon.ID>) async throws -> [Pokemon]
	var updatePokemonIsConnected: (_ isConnected: Bool, _ id: Pokemon.ID) async throws -> Void
}

extension Repository: DependencyKey {
	static let liveValue: Repository = {
		@Dependency(\.apiClient) var apiClient
		@Dependency(\.databaseClient) var database

		func pokemons(for ids: Set<Pokemon.ID>) async throws -> [Pokemon] {
			await withTaskGroup(of: Pokemon?.self) { group in
				var pokemons: [Pokemon] = []

				for id in ids {
					group.addTask {
						if let storedPokemon = try? await database.pokemon(id: id) {
							return storedPokemon
						}

						if let remotePokemon = try? await apiClient.pokemon(id: id) {
							try? await database.savePokemon(remotePokemon)
							return remotePokemon
						}
						return nil
					}
				}

				for await result in group {
					if let pokemon = result {
						pokemons.append(pokemon)
					}
				}

				return pokemons
			}
		}

		return Self(
			homeData: {
				let eventsResponse = EventsResponse.mock
				let allPokemonIDs = eventsResponse.allPokemonIDs

				let pokemons = try await pokemons(for: allPokemonIDs)

				return .init(featuredEvent: eventsResponse.featuredEvent,
							 weaklyEvents: eventsResponse.weaklyEvents,
							 popularPokemons: pokemons.sorted(by: { $0.order < $1.order }))
			},

			pokemons: { ids in
				let result = try await pokemons(for: ids)
				return result.sorted(by: { $0.id < $1.id })
			},

			updatePokemonIsConnected: { isConnected, id in
				try await database.updatePokemonIsConnected(isConnected, id)
			}
		)
	}()
}

extension Repository: TestDependencyKey {
	static let previewValue = Self(
		homeData: { .mock },
		pokemons: {_ in .mock },
		updatePokemonIsConnected: { _,_  in }
	)

	static let testValue = Self()
}

extension DependencyValues {
	var repository: Repository {
		get { self[Repository.self] }
		set { self[Repository.self] = newValue }
	}
}

