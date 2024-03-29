//
//  PokemonTaskApp.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import ComposableArchitecture
import SwiftUI

@main
struct PokemonTaskApp: App {
	var body: some Scene {
		WindowGroup {
			MainView(store: Store(
				initialState: MainFeature.State()) {
					MainFeature()
				}
			)
		}
	}
}
