import Models
import ComposableArchitecture
import Mocks
import PokemonDetailsFeature
import XCTest

final class PokemonDetailsFeatureTests: XCTestCase {

	@MainActor
    func testConnect() async {
		var pokemon = Pokemon.bulbasaur
		pokemon.isConnected = true

		let store = TestStore(initialState: PokemonDetailsFeature.State(pokemon: pokemon)) {
			PokemonDetailsFeature()
		} withDependencies: {
			$0.repository.updatePokemonIsConnected = { _, _ in }
		}

		await store.send(.connectButtonTapped) // State not changed

		await store.receive(\.updatePokemon) {
			$0.pokemon.isConnected = false // State changed
		}

		await store.send(.connectButtonTapped) // State not changed

		await store.receive(\.updatePokemon) {
			$0.pokemon.isConnected = true // State changed
		}

    }
}
