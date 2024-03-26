//
//  DatabaseClient.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import Foundation
import ComposableArchitecture
import CoreData

@DependencyClient
struct DatabaseClient {
	var pokemon: @MainActor (_ id: Int32) async throws -> Pokemon?
	var savePokemon: @MainActor (Pokemon) async throws -> Void
	var updatePokemonIsConnected: @MainActor (_ isConnected: Bool, _ id: Int32) async throws -> Void
}

enum DatabaseClientError: Error {
	case objectNotExists
}


// MARK: - Live client

extension DatabaseClient: DependencyKey {
	
	static var liveValue: Self {
		var viewContext: NSManagedObjectContext {
			return persistentContainer.viewContext
		}
		
		lazy var persistentContainer: NSPersistentContainer = {
			let container = NSPersistentContainer(name: "Pokemons")
			container.loadPersistentStores { _, error in
				if let error = error as NSError? {
					fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
				}
			}
			container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			return container
		}()
		
		return Self(
			
			pokemon: { id in
				let request = PokemonEntity.fetchRequest()
				request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))

				let entities = try viewContext.fetch(request)

				return entities.first?.toPokemon()
			},
			
			savePokemon: { pokemon in
				try await viewContext.perform {
					let entity = PokemonEntity(context: viewContext)
					entity.update(from: pokemon)

					try viewContext.save()
				}
			},
			
			updatePokemonIsConnected: { isConnected, id in
				let request = PokemonEntity.fetchRequest()
				request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
				
				let entities = try viewContext.fetch(request)
				
				guard let entity = entities.first else {
					throw DatabaseClientError.objectNotExists
				}
				
				try await viewContext.perform {
					entity.isConnected = isConnected
					try viewContext.save()
				}
			})
	}
}

extension DatabaseClient: TestDependencyKey {
	static let previewValue = Self(
		pokemon: { _ in .bulbasaur },
		savePokemon: { _ in },
		updatePokemonIsConnected: { _,_ in }
	)

	static let testValue = Self()
}

extension DependencyValues {
	var databaseClient: DatabaseClient {
		get { self[DatabaseClient.self] }
		set { self[DatabaseClient.self] = newValue }
	}
}

