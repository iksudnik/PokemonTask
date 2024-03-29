import Foundation
import Models

public extension Pokemon {
	static let bulbasaur = Self(id: 1, name: "Bulbasaur", height: 10, weight: 39,
								order: 1, imageUrl: mockImageUrl(1), isConnected: false)

	static let charizard = Self(id: 6, name: "Bulbasaur", height: 13, weight: 24,
							   order: 2, imageUrl: mockImageUrl(6), isConnected: true)

	static let pidgeotto = Self(id: 17, name: "Pidgeotto", height: 8, weight: 15,
								order: 3, imageUrl: mockImageUrl(17), isConnected: true)

	static let pidgeottoWithoutImage = Self(id: 17, name: "Pidgeotto", height: 8, weight: 15, order: 3, isConnected: true)

	private static func mockImageUrl(_ id: Int) -> URL? {
		URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
	}
}

public extension [Pokemon] {
	static let mock: Self = [.bulbasaur, .charizard, .pidgeotto]
}
