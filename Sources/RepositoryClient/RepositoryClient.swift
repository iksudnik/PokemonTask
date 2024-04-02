import Dependencies
import DependenciesMacros
import Foundation
import Models
import Mocks

@DependencyClient
public struct RepositoryClient: Sendable {
	public var homeData: @Sendable () async throws -> HomeResponse
	public var pokemons: @Sendable (Set<Pokemon.ID>) async throws -> [Pokemon]
	public var updatePokemonIsConnected: @Sendable (_ isConnected: Bool, _ id: Pokemon.ID) async throws -> Void
}

extension RepositoryClient: TestDependencyKey {
	public static let previewValue = Self(
		homeData: { .mock },
		pokemons: {_ in .mock },
		updatePokemonIsConnected: { _,_  in }
	)

	public static let testValue = Self()
}

extension DependencyValues {
	public var repository: RepositoryClient {
		get { self[RepositoryClient.self] }
		set { self[RepositoryClient.self] = newValue }
	}
}


