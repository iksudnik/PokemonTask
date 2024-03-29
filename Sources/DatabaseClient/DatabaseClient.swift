import Dependencies
import DependenciesMacros
import Foundation
import Models
import Mocks

@DependencyClient
public struct DatabaseClient {
	public var pokemon: @MainActor (_ id: Pokemon.ID) async throws -> Pokemon?
	public var savePokemon: @MainActor (Pokemon) async throws -> Void
	public var updatePokemonIsConnected: @MainActor (_ isConnected: Bool, _ id: Pokemon.ID) async throws -> Void
}

public enum DatabaseClientError: Error {
	case objectNotExists
}

extension DatabaseClient: TestDependencyKey {
	public static let previewValue = Self(
		pokemon: { _ in .bulbasaur },
		savePokemon: { _ in },
		updatePokemonIsConnected: { _,_ in }
	)

	public static let testValue = Self()
}

extension DependencyValues {
	public var databaseClient: DatabaseClient {
		get { self[DatabaseClient.self] }
		set { self[DatabaseClient.self] = newValue }
	}
}

