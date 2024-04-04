import AppFeature
import HomeFeature
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
		let pokemons = [Pokemon].mock

		let store = TestStore(initialState: AppFeature.State()) {
			AppFeature()
		} withDependencies: {
			$0.repository.homeData = { homeResponse }
			$0.repository.updatePokemonIsConnected = { @Sendable _, _ in }
			$0.repository.pokemons = { _ in pokemons }
		}

		// Select home tab
		await store.send(\.selected, .home)

		// Send onTask action on HomeFeature
		await store.send(\.home.onTask)

		// Recieving homeResponseResult action
		// Check Home state was updated
		await store.receive(\.home.homeResponseResult) {
			$0.home.loadingState = .loaded
			$0.home.featuredEvent = .init(event: homeResponse.featuredEvent)
			$0.home.events = .init(events: .init(uniqueElements: homeResponse.weaklyEvents))
			$0.home.pokemons = .init(pokemons: .init(uniqueElements: homeResponse.popularPokemons))
			$0.home.topBar.locations = homeResponse.locations
		}

		let event = Event.event1
		// Tap on Event in EventsList
		// Check that EventDetailsFeature was pushed
		await store.send(\.home.events.delegate.eventTapped, event) {
			$0.home.path[id: 0] = .eventDetails(.init(event: event))
		}

		// Send onTask action on HomeFeature
		// Check that changes isLoading in EventDetailsFeature state
 		await store.send(\.home.path[id: 0].eventDetails.onTask) {
			$0.home.path[id: 0]?.eventDetails?.isLoading = true
		}

		// Check that pokemonsResponse action was received
		// And state was updated
		await store.receive(\.home.path[id: 0].eventDetails.pokemonsResponse) {
			$0.home.path[id: 0]?.eventDetails?.pokemons = .init(pokemons: .init(uniqueElements: pokemons))
		}

		let firstPokemon = pokemons[0]

		// Tap on first pokemon in PokemonsList
		// Check that PokemonDetailsFeature was pushed
		await store.send(\.home.pokemons.delegate.pokemonTapped, firstPokemon) {
			$0.home.path[id: 1] = .pokemonDetails(.init(pokemon: firstPokemon))
		}

		// Tap Connect button on PokemonDetails
		await store.send(\.home.path[id: 1].pokemonDetails.connectButtonTapped)

		// Check that updatePokemon action was receved
		// Check that PokemonDetails state was updated
		await store.receive(\.home.path[id: 1].pokemonDetails.updatePokemon) {
			$0.home.path[id: 1]?.pokemonDetails?.pokemon.isConnected = true
		}


		// Return back to EventDetails
		// Check that PokemonDetails state is nil
		await store.send(\.home.path.popFrom, 1) {
			$0.home.path[id: 1] = nil
		}

		// Return back to Home
		// Check that Navigation stack is empty
		await store.send(\.home.path.popFrom, 0) {
			$0.home.path = StackState()
		}
	}
}
