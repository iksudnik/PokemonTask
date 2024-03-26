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
	var pokemones: @MainActor () async throws -> PokemonResponse
	var savePokemons: @MainActor (PokemonResponse) async throws -> Void
	var updatePokemonIsConnected: @MainActor (_ isConnected: Bool, _ id: Int) async throws -> Void
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
			
			pokemones: {
				let pokemonesRequest = PokemonEntity.fetchRequest()
				let sortDescriptor = NSSortDescriptor(keyPath: \PokemonEntity.id, ascending: true)
				pokemonesRequest.sortDescriptors = [sortDescriptor]
				let entities = try viewContext.fetch(pokemonesRequest)
				
				let downloadStateRequest = DownloadState.fetchRequest()
				let downloadState = (try? viewContext.fetch(downloadStateRequest))?.first
				
				return .init(count: Int(downloadState?.maxCount ?? .max),
							 next: downloadState?.nextUrl,
							 results: entities.map { $0.toPokemon() })
			},
			
			savePokemons: { response in
				try await viewContext.perform {
					for pokemon in response.results {
						let entity = PokemonEntity(context: viewContext)
						entity.update(from: pokemon)
					}
					
					var downloadState = try viewContext.fetch(DownloadState.fetchRequest()).first
					if downloadState == nil {
						downloadState = DownloadState(context: viewContext)
					}
					downloadState?.maxCount = Int32(response.count)
					downloadState?.nextUrl = response.next
					
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
		pokemones: { .mock},
		savePokemons: { _ in },
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

