import Foundation
import Dependencies
import Models

extension ApiClient: DependencyKey {
	private static func pokemonUrl(for id: Pokemon.ID) -> URL {
		URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
	}
	
	public static let liveValue = Self(
		pokemon: { id in
			let url = pokemonUrl(for: id)
			let (data, _) = try await URLSession.shared.data(from: url)
			return try JSONDecoder().decode(Pokemon.self, from: data)
		}
	)
}
