import Dependencies
import DependenciesMacros
import Foundation
import Models
import Mocks

@DependencyClient
public struct ApiClient {
	public var pokemon: (_ id: Pokemon.ID) async throws -> Pokemon
}

extension ApiClient: TestDependencyKey {
	public static let previewValue = Self(
		pokemon: { _ in .bulbasaur }
	)

	public static let testValue = Self()
}

extension DependencyValues {
	public var apiClient: ApiClient {
		get { self[ApiClient.self] }
		set { self[ApiClient.self] = newValue }
	}
}

