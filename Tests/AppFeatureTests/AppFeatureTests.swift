import AppFeature
import Mocks
import Models
import ComposableArchitecture
import XCTest

final class AppFeatureTests: XCTestCase {

	@MainActor
    func testTabs() async {
		let store = TestStore(initialState: AppFeature.State()) {
			AppFeature()
		}

		// Select Search tab and check that state was changed
		await store.send(.selected(.search)) {
			$0.selection = .search
		}

		// Select Tickets tab and check that state was changed
		await store.send(.selected(.tickets)) {
			$0.selection = .tickets
		}

		// Select Home tab and check that state was changed
		await store.send(.selected(.home)) {
			$0.selection = .home
		}
    }

	@MainActor
	func testIntegration() async {
		let homeResponse = HomeResponse.mock
		
		let store = TestStore(initialState: AppFeature.State()) {
			AppFeature()
		} withDependencies: {
			$0.repository.homeData = {
				homeResponse
			}
			$0.repository.updatePokemonIsConnected = { _, _ in }
		}

		// Select home tab
		await store.send(\.selected, .home)

		// Tun onTask action on HomeFeature
		await store.send(\.home.onTask)

		// Recieving homeResponseResult action
		// Check Home state was updated
		await store.receive(\.home.homeResponseResult) {
			$0.home.loadingState = .loaded
			$0.home.featuredEvent = .init(event: homeResponse.featuredEvent)
			$0.home.events = .init(events: .init(uniqueElements: homeResponse.weaklyEvents))
			$0.home.pokemons = .init(pokemons: .init(uniqueElements: homeResponse.popularPokemons))
		}

		let bulbasaur = Pokemon.bulbasaur

		// Tap on Bulbasaur in PokemonsList
		// Check that PokemonDetailsFeature was pushed
		await store.send(\.home.pokemons.delegate.pokemonTapped, bulbasaur) {
			$0.home.path[id: 0] = .pokemonDetails(.init(pokemon: bulbasaur))
		}

		// Tap Connect button on PokemonDetails
		await store.send(\.home.path[id: 0].pokemonDetails.connectButtonTapped)

		// Check that PokemonDetails state was updated
		await store.receive(\.home.path[id: 0].pokemonDetails.updatePokemon) {
			$0.home.path[id: 0]?.pokemonDetails?.pokemon.isConnected = true
		}

		// Return back to Home
		// Check that Navigation stack is empty
		await store.send(\.home.path.popFrom, 0) {
			$0.home.path = StackState()
		}
	}

}
