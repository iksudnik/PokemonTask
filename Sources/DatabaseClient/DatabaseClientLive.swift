import CoreData
import Dependencies
import Foundation
import Models

open class PersistentContainer: NSPersistentContainer { }

extension DatabaseClient: DependencyKey {

	public static var liveValue: Self {
		var viewContext: NSManagedObjectContext {
			return persistentContainer.viewContext
		}

		lazy var persistentContainer: PersistentContainer = {

			guard let modelURL = Bundle.module.url(forResource:"Pokemons", withExtension: "momd"),
				  let model = NSManagedObjectModel(contentsOf: modelURL)
			else {
				fatalError()
			}

			let container = PersistentContainer(name:"Pokemons", managedObjectModel: model)
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
			}
		)
	}
}

extension PokemonEntity {
	func toPokemon() -> Pokemon {
		.init(id: id, name: name ?? "", height: height, weight: weight,
			  order: order, imageUrl: imageUrl, isConnected: isConnected)
	}

	func update(from pokemon: Pokemon) {
		id = pokemon.id
		name = pokemon.name
		height = pokemon.height
		weight = pokemon.weight
		order = pokemon.order
		imageUrl = pokemon.imageUrl
		isConnected = pokemon.isConnected
	}
}
